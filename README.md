# Automated Multi-VM Local Infrastructure Setup with Vagrant & VirtualBox

## Project Description
This project automates the provisioning of an isolated, multi-tiered application environment on a local machine using **Vagrant** and **VirtualBox**. It simulates a production-grade microservices architecture by spinning up dedicated virtual machines for each component of the application stack, fully automated via custom shell provisioning scripts.

It demonstrates key DevOps practices including Infrastructure as Code (IaC), automated configuration management, isolated service networking, and repeatable local environment orchestration.

---

## Architecture Overview
The setup orchestrates multiple dedicated virtual machines configured to communicate over a private network:

* **Web Server (Nginx):** Acts as the reverse proxy and entry point, routing incoming web requests.
* **Application Server (Apache Tomcat):** Hosts and executes the core Java web application logic.
* **Database Server (MariaDB / MySQL):** Provides persistent relational data storage.
* **Cache Server (Memcached):** Reduces database load by handling session management and high-frequency queries.
* **Message Queue Server (RabbitMQ):** Manages asynchronous messaging and background task queuing[cite: 1].

### Workflow & Infrastructure Diagram
```text
[ Client Request ]
        │
        ▼
  [ Nginx VM ] (Reverse Proxy)
        │
        ▼
 [ Tomcat App VM ] ───► [ Memcached VM ] (In-Memory Cache)
        │
        ├─────────────► [ RabbitMQ VM ]  (Message Broker)
        │
        └─────────────► [ MariaDB VM ]   (Relational DB)

Tech Stack & Tools
Virtualization Provider: Oracle VM VirtualBox[cite: 1]

Environment Orchestration: Vagrant (Vagrantfile)[cite: 1]

Provisioning & Automation: Shell Scripts (Bash)[cite: 1]

Web & Application Servers: Nginx, Apache Tomcat[cite: 1]

Databases & Caching: MariaDB / MySQL, Memcached[cite: 1]

Message Broker: RabbitMQ[cite: 1]

Operating System: Ubuntu / CentOS base boxes[cite: 1]

Deployment & Setup Instructions
Prerequisites
Ensure the following tools are installed on your host machine:

VirtualBox (v6.1 or higher)

Vagrant (v2.2 or higher)

Git

Quick Start
Clone the Repository:

Bash
git clone [https://github.com/samahghazala/vagrant-multi-vm-environment.git](https://github.com/samahghazala/vagrant-multi-vm-environment.git)
cd vagrant-multi-vm-environment
Spin Up the Multi-VM Environment:
Run the following command to download base boxes, initialize private networking, and execute all provisioning scripts automatically[cite: 1]:

Bash
vagrant up
Verify Running Virtual Machines:

Bash
vagrant status
Access Individual Services:
You can SSH directly into any specific VM using its defined hostname in the Vagrantfile:

Bash
vagrant ssh web01   # Connect to Nginx Web Server
vagrant ssh app01   # Connect to Tomcat App Server
vagrant ssh db01    # Connect to MariaDB Server
Clean Up Environment:
To destroy all VMs and free up system resources:

Bash
vagrant destroy -f
