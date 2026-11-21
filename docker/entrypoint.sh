#!/bin/sh
# 通常Docker / rootless Docker の両方で同じイメージを使うための entrypoint
#   - /sandbox の所有者が uid 0 に見える → rootless。root のまま実行
#   - それ以外 → 通常Docker。その uid/gid の "dev" ユーザーに降格して実行
set -e

: "${OWNER_REF:=/home/dev/sandbox}"   # 所有者判定の基準にするマウント先
: "${DEV_USER:=dev}"

# すでに非rootで起動されている（--user 指定など）ならそのまま
if [ "$(id -u)" != "0" ]; then
  exec "$@"
fi

uid=0
gid=0
if [ -d "$OWNER_REF" ]; then
  uid=$(stat -c %u "$OWNER_REF")
  gid=$(stat -c %g "$OWNER_REF")
fi

# ディレクトリの所有者が違うときだけ chown -R（2回目以降の起動はスキップ）
fix_owner() {
  [ -d "$1" ] || return 0
  if [ "$(stat -c %u:%g "$1")" != "$uid:$gid" ]; then
    chown -R "$uid:$gid" "$1"
  fi
}

if [ "$uid" = "0" ]; then
  # ---- rootless Docker: コンテナ内 root = ホストの自分 ----
  # `docker compose exec -u dev` を両環境で使えるよう、uid 0 の別名 dev を作る
  getent passwd "$DEV_USER" >/dev/null || \
    useradd -o -u 0 -g 0 -M -d "$HOME" -s /bin/zsh "$DEV_USER"
  exec "$@"
fi

# ---- 通常Docker: ホストの uid/gid に合わせたユーザーを作って降格 ----
getent group "$gid" >/dev/null || groupadd -o -g "$gid" "$DEV_USER"
getent passwd "$DEV_USER" >/dev/null || \
  useradd -o -u "$uid" -g "$gid" -M -d "$HOME" -s /bin/zsh "$DEV_USER"

fix_owner "$HOME"
fix_owner "${UV_CACHE_DIR:-}"

export USER="$DEV_USER" LOGNAME="$DEV_USER"
exec setpriv --reuid="$uid" --regid="$gid" --init-groups "$@"
