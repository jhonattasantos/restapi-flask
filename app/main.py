from flask import Flask
from flask_restful import Api, Resource, reqparse

app = Flask(__name__)
api = Api(app)

users = [
    {"id": 1, "username": "admin", "email": "admin@example.com"},
    {"id": 2, "username": "user1", "email": "user1@example.com"}
]

user_parser = reqparse.RequestParser()
user_parser.add_argument('username', type=str, required=True, help='Nome de usuário é obrigatório')
user_parser.add_argument('email', type=str, required=True, help='Email é obrigatório')

class Users(Resource):
    def get(self, user_id=None):
        global users
        
        # Se um ID for fornecido, retorna um usuário específico
        if user_id:
            user = next((user for user in users if user["id"] == user_id), None)
            if not user:
                return {"message": "Usuário não encontrado"}, 404
            return user, 200
        
        # Caso contrário, retorna todos os usuários
        return users, 200
    
    def post(self):
        global users
        args = user_parser.parse_args()
        
        # Verifica se o usuário já existe
        if any(user["username"] == args["username"] for user in users):
            return {"message": "Usuário já existe"}, 409
        
        # Gera um novo ID para o usuário
        user_id_counter = len(users) + 1
        
        # Cria novo usuário
        new_user = {
            "id": user_id_counter,
            "username": args["username"],
            "email": args["email"]
        }
        
        users.append(new_user)
        
        return new_user, 201
    
    def put(self, user_id):
        global users
        
        # Encontra o usuário pelo ID
        user = next((user for user in users if user["id"] == user_id), None)
        if not user:
            return {"message": "Usuário não encontrado"}, 404
        
        # Atualiza os dados do usuário
        args = user_parser.parse_args()
        user["username"] = args["username"]
        user["email"] = args["email"]
        
        return user, 200
    
    def delete(self, user_id):
        global users
        
        # Encontra o usuário pelo ID
        user = next((user for user in users if user["id"] == user_id), None)
        if not user:
            return {"message": "Usuário não encontrado"}, 404
        
        # Remove o usuário da lista
        users = [user for user in users if user["id"] != user_id]
        
        return {"message": "Usuário excluído com sucesso"}, 200


api.add_resource(Users, "/users", "/users/<int:user_id>")


if __name__ == "__main__":
    app.run(debug=True)
