#!/bin/sh

# default daily
CRON=${CRON:-"0   2    *   *   *"}

CONFIG=/config

generate_ssh_key() {
    if [ -f "$CONFIG/id_rsa.pub" -a -f "$CONFIG/id_rsa" ]; then
        mkdir -p ~/.ssh
        chmod 0700 ~/.ssh
        cp "$CONFIG/id_rsa.pub" ~/.ssh/id_rsa.pub
        cp "$CONFIG/id_rsa" ~/.ssh/id_rsa
        chmod 0644 ~/.ssh/id_rsa.pub
        chmod 0600 ~/.ssh/id_rsa
    else
        echo "Generating ssh keys..."
        ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ""
        cp ~/.ssh/id_rsa.pub "$CONFIG/"
        cp ~/.ssh/id_rsa "$CONFIG/"
    fi
}

setup_ssh_config() {
    if grep "StrictHostKeyChecking no" /etc/ssh/ssh_config &>/dev/null; then
        return 0
    fi
    echo "Setup ssh config..."
    cat << EOF >> /etc/ssh/ssh_config
Host *
    StrictHostKeyChecking no
EOF
}

generate_ssh_key

setup_ssh_config

echo "Pubkey start  >>>>>>>>>>>>"
cat ~/.ssh/id_rsa.pub
echo "Pubkey end    <<<<<<<<<<<<"

echo "Please set this pubkey to your git server."

cat << EOF > /var/spool/cron/crontabs/root
$CRON /backup.sh
EOF

exec crond -f -l 8
