flowchart LR

    subgraph HK1["HK1<br/>Public IP: 111.111.111.111"]
    end

    subgraph UK1["UK1<br/>Public IP: 222.222.222.222"]
    end

    subgraph USA["USA<br/>Public IP: 333.333.333.333"]
    end

    HK1 <--> |"S1<br/>10.255.1.1 ↔ 10.255.1.2"| UK1
    HK1 <--> |"S2<br/>10.255.1.5 ↔ 10.255.1.6"| UK1
    HK1 <--> |"S3<br/>10.255.1.9 ↔ 10.255.1.10"| UK1

    UK1 <--> |"A1<br/>10.255.2.1 ↔ 10.255.2.2"| USA
    HK1 <--> |"B1<br/>10.255.3.1 ↔ 10.255.3.2"| USA
