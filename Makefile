.PHONY: setup run clean test lint format install update

# Define a variável para o Python da versão do Poetry
PYTHON = poetry run python

# Configuração inicial do projeto
setup:
	@echo "Configurando o projeto..."
	poetry install
	@echo "Configuração concluída!"

# Executar a aplicação Flask
run:
	@echo "Iniciando a aplicação Flask..."
	$(PYTHON) run.py

# Executar a aplicação em modo de desenvolvimento
dev:
	@echo "Iniciando a aplicação com recarregamento automático..."
	FLASK_ENV=development FLASK_DEBUG=1 $(PYTHON) run.py

# Limpar arquivos temporários
clean:
	@echo "Limpando arquivos temporários..."
	rm -rf __pycache__
	rm -rf app/__pycache__
	rm -rf .pytest_cache
	rm -rf .coverage
	@echo "Limpeza concluída!"

# Executar testes
test:
	@echo "Executando testes..."
	$(PYTHON) -m pytest

# Verificar qualidade do código
lint:
	@echo "Verificando qualidade do código..."
	$(PYTHON) -m flake8 app
	$(PYTHON) -m mypy app

# Formatar código automaticamente
format:
	@echo "Formatando código..."
	$(PYTHON) -m black app
	$(PYTHON) -m isort app

# Instalar dependências de desenvolvimento
install-dev:
	@echo "Instalando dependências de desenvolvimento..."
	poetry add --group dev pytest flake8 black isort mypy

# Atualizar dependências
update:
	@echo "Atualizando dependências..."
	poetry update

# Criar nova migração do banco de dados (se estiver usando um ORM)
db-migrate:
	@echo "Criando nova migração do banco de dados..."
	$(PYTHON) -m flask db migrate -m "$(m)"

# Aplicar migrações
db-upgrade:
	@echo "Aplicando migrações do banco de dados..."
	$(PYTHON) -m flask db upgrade

# Mostrar ajuda
help:
	@echo "Comandos disponíveis:"
	@echo "  make setup        - Instalar dependências e configurar o projeto"
	@echo "  make run          - Executar a aplicação Flask"
	@echo "  make dev          - Executar a aplicação em modo de desenvolvimento"
	@echo "  make clean        - Limpar arquivos temporários"
	@echo "  make test         - Executar testes"
	@echo "  make lint         - Verificar qualidade do código"
	@echo "  make format       - Formatar código automaticamente"
	@echo "  make install-dev  - Instalar dependências de desenvolvimento"
	@echo "  make update       - Atualizar dependências"
	@echo "  make db-migrate   - Criar nova migração (use make db-migrate m='mensagem')"
	@echo "  make db-upgrade   - Aplicar migrações"