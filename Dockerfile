FROM mcr.microsoft.com/devcontainers/typescript-node

# 选择一个时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 设置默认用户为 node
USER root

RUN apt update

# install 
RUN sudo apt install zsh tmux exa jq -y

# install lazygit
# RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
# RUN curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
# RUN tar xf lazygit.tar.gz lazygit
# RUN sudo install lazygit /usr/local/bin
# RUN echo $(lazygit --version)

# 更改默认 shell 为 zsh
RUN sudo chsh -s /bin/zsh

# install ohmyzsh 
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install zsh plusin
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z

# install spaceship
RUN git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1

RUN ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# install nvim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
RUN chmod u+x nvim.appimage
RUN ./nvim.appimage --appimage-extract
RUN ./squashfs-root/AppRun --version
# 就是在 / 目录下执行的， 所以不用 `mv`
# RUN sudo mv squashfs-root /
RUN sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
RUN echo $(nvim -v)

COPY ./.zshrc /root/.zshrc
COPY ./.tmux.conf /root/.tmux.conf
RUN echo "2333" >> /root/demo.txt

RUN corepack enable

# RUN apt-get update && \
#     apt-get install -y tmux exa

RUN pnpm -v 

RUN node -v

CMD ["/bin/zsh", "-c", "while true; do echo hello; sleep 10; done"]