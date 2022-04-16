# iptables

## About iptables
iptables is a command-line firewall utility that uses policy chains to allow or block traffic. At the time of establishing a connection, iptables looks up in its list, for a rule that matches the criteria to either accept, drop or return the packet. 

## To install 
```sudo apt-get install iptables```

## Types of Chains
* **Input**: Used to control incoming packets destined for the local system.
* **Forward**: Used to control incoming packets that needs to be forwarded to a different host. 
* **Output**: Used to control outgoing packets.

## Using iptables on CloudLab
* To list all the rules

        sudo iptables -L

* To insert a new rule to the chain that accepts an incoming packet from a particluar source.

        sudo iptables -I INPUT -s <SOURCE_IP> -p <PROTOCOL> -m <MATCH> --dport <PORT> -j ACCEPT

    eg: ```sudo iptables -I INPUT -s 134.193.129.47 -p tcp -m tcp --dport 8080 -j ACCEPT```

* To insert a new rule to the chain that drops an incoming packet from any source.::
        
        sudo iptables -I INPUT -p <PROTOCOL> -m <MATCH> --dport <PORT> -j DROP

    eg: ```sudo iptables -I INPUT  -p tcp -m tcp --dport 8080 -j DROP```

* To enable localhost traffic.::

        sudo iptables -A INPUT -i lo -j ACCEPT

* To restart the sshd service
       
       sudo /etc/init.d/ssh restart
         
## References

[Linux man page](https://linux.die.net/man/8/iptables/) <br>
[The Beginner’s Guide to iptables, the Linux Firewall](https://www.howtogeek.com/177621/the-beginners-guide-to-iptables-the-linux-firewall/) <br>
[Iptables Tutorial](https://www.hostinger.com/tutorials/iptables-tutorial)
