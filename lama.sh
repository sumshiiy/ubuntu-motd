sudo apt install -y figlet && \
sudo chmod -x /etc/update-motd.d/* && \
sudo curl -o /etc/update-motd.d/00-custom https://raw.githubusercontent.com/sumshiiy/ubuntu-motd/refs/heads/main/login.sh && \
sudo chmod +x /etc/update-motd.d/00-custom
echo "Done"
