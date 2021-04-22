
Dependencies:

------

    apt update
    apt install sshpass -y

------

ansible.cfg

------

    [defaults]
    system_warnings = False
    deprecation_warnings = false
    inventory      = hosts

------

hosts

------

    jd ansible_host=localhost ansible_connection=local
    linux-server ansible_host=192.168.0.107 ansible_user=linux ansible_connection=ssh ansible_ssh_pass=.

---

command

------

    ansible --version
    ansible -m ping all # m refer for module. all is refer for all hosts

------
