
FROM golang:bullseye

WORKDIR /kujira

RUN apt update -y 
RUN apt upgrade -y
RUN apt install -y build-essential git unzip curl wget
RUN git clone https://github.com/Team-Kujira/core

WORKDIR /kujira/core

RUN git checkout v0.4.0
RUN make install
RUN kujirad init "D4FTKujira" --chain-id harpoon-4
RUN wget https://raw.githubusercontent.com/Team-Kujira/networks/master/testnet/harpoon-4.json -P $HOME/.kujira/config
RUN mv $HOME/.kujira/config/harpoon-4.json $HOME/.kujira/config/genesis.json
RUN wget https://raw.githubusercontent.com/Team-Kujira/networks/master/testnet/addrbook.json -P $HOME/.kujira/config
RUN sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00125ukuji\"/;" $HOME/.kujira/config/app.toml
RUN sed -i "s/^timeout_commit *=.*/timeout_commit = \"1500ms\"/;" $HOME/.kujira/config/config.toml

ENTRYPOINT ["kujirad", "start"]