## Prints - Prova de Infraestrutura

# docker compose ps
![alt text](dockercompose.png)

# docker network inspect gymdata_prova_app-network
![alt text](dockernetwork.png)

# docker exec gymdata_app ping -c 3 db
![alt text](dockerping.png)

# chmod +x deploy.sh
# ./deploy.sh --skip-ecr
![alt text](deploysh.png)

# Persistência — ANTES do restart
# curl http://localhost:8080/api/alunos -H "Authorization: Bearer $TOKEN"
![alt text](dadosaluno.png)

# docker compose restart db
![alt text](dockerrestart.png)

# Persistência — DEPOIS do restart (dados ainda lá)
# curl http://localhost:8080/api/alunos -H "Authorization: Bearer $TOKEN"
![alt text](persistencia.png)

# Segurança — banco inacessível pelo host (deve dar erro)
# curl http://localhost:5432
![alt text](bancobloqueado.png)

# Segurança — Node inacessível direto (deve dar erro)
# curl http://localhost:3000
![alt text](nodebloqueado.png)