# RIG.BUILD — Deploy do Zero

Guia completo: do nada até a aplicação no ar com banco de dados e login. Tempo estimado: **30-40 min** na primeira vez.

## O que você vai fazer

1. Criar conta no **GitHub** (grátis) — guarda seu código
2. Criar conta no **Supabase** (grátis) — banco de dados + login
3. Criar conta na **Vercel** (grátis) — hospedagem
4. Subir o código e conectar tudo

Não precisa instalar nada no computador além de um editor de texto (VSCode é o mais usado, mas o próprio site do GitHub serve para começar).

---

## PARTE 1 — GitHub (5 min)

GitHub é onde seu código vai morar. Vercel puxa de lá automaticamente.

1. Acesse https://github.com e clique em **Sign up**. Crie sua conta com email e senha.
2. Confirme o email.
3. No canto superior direito, clique no `+` → **New repository**.
4. Nome: `rig-build` (ou o que preferir).
5. Marque **Public** (mais simples para Vercel grátis).
6. **NÃO** marque "Add a README" — vamos subir os arquivos depois.
7. Clique em **Create repository**.
8. Você verá uma página com instruções. Vamos voltar nela depois.

---

## PARTE 2 — Supabase (10 min)

Supabase é o banco de dados + sistema de login.

### 2.1 Criar projeto

1. Acesse https://supabase.com e clique em **Start your project**.
2. Faça login com a conta GitHub que acabou de criar (mais rápido).
3. Clique em **New project**.
4. Preencha:
   - **Name**: `rig-build`
   - **Database Password**: gere uma senha forte e **guarde num lugar seguro** (você não vai usar agora, mas vai precisar se for mexer direto no banco depois)
   - **Region**: `South America (São Paulo)` — fica mais rápido
   - **Pricing Plan**: Free
5. Clique em **Create new project** e aguarde uns 2 minutos enquanto provisiona.

### 2.2 Criar a tabela e configurar segurança

Quando o projeto estiver pronto:

1. No menu lateral esquerdo, clique no ícone de **SQL Editor** (parece um `>_`).
2. Clique em **+ New query**.
3. Cole o conteúdo INTEIRO do arquivo `supabase-setup.sql` que está no projeto.
4. Clique em **Run** (botão verde no canto inferior direito, ou Ctrl+Enter).
5. Deve aparecer "Success. No rows returned" — pronto, sua tabela foi criada com segurança ativada.

### 2.3 Pegar suas chaves de API

1. No menu lateral, clique no ícone de **engrenagem** (Settings) no canto inferior esquerdo.
2. Clique em **API**.
3. Você vai ver duas informações importantes — copie e guarde num bloco de notas:
   - **Project URL** (algo como `https://abcdefg.supabase.co`)
   - **anon public** key (uma string longa começando com `eyJ...`)

> ⚠️ A chave `anon public` é segura para colocar no front-end — ela só consegue fazer o que as regras de segurança (RLS) permitirem. **NUNCA** use a `service_role` no front-end.

### 2.4 Configurar autenticação por email

1. No menu lateral, clique em **Authentication** → **Providers**.
2. **Email** já vem ativado por padrão. Clique em **Email** para abrir as opções.
3. Para teste rápido: **desligue** a opção "Confirm email" (assim você não precisa confirmar email toda vez que cadastra alguém). Em produção real, deixe ligado.
4. Clique em **Save**.

---

## PARTE 3 — Configurar o código

Agora vamos colocar suas chaves no código.

1. Abra o arquivo `config.js` que está no projeto.
2. Substitua os dois valores pelos que você copiou da Supabase:

```js
const SUPABASE_URL = 'https://SEU-PROJETO.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGc...sua-chave-aqui';
```

3. Salve o arquivo.

---

## PARTE 4 — Subir para o GitHub

Você tem duas opções. Escolha a mais fácil para você:

### Opção A — Pelo site do GitHub (mais simples, sem instalar nada)

1. Volte para a página do seu repositório `rig-build` no GitHub.
2. Clique em **uploading an existing file** (link que aparece no meio da página).
3. Arraste TODOS os arquivos do projeto (`index.html`, `config.js`, etc.) para a área indicada.
4. Embaixo, escreva uma mensagem como "primeiro upload" e clique em **Commit changes**.

### Opção B — Pelo Git no terminal (se você quiser aprender o jeito profissional)

```bash
cd caminho/para/a/pasta/do/projeto
git init
git add .
git commit -m "primeiro upload"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/rig-build.git
git push -u origin main
```

---

## PARTE 5 — Deploy na Vercel (5 min)

1. Acesse https://vercel.com e clique em **Sign Up**.
2. Escolha **Continue with GitHub** (vai logar com a mesma conta do GitHub).
3. Autorize a Vercel a ver seus repositórios.
4. No painel da Vercel, clique em **Add New...** → **Project**.
5. Encontre seu repositório `rig-build` na lista e clique em **Import**.
6. Não precisa mudar NADA nas configurações — a Vercel detecta que é um site estático automaticamente.
7. Clique em **Deploy**.
8. Espere 30 segundos. Pronto, seu site está no ar!

A Vercel te dá uma URL tipo `https://rig-build-seunome.vercel.app`. Compartilhe com quem você quiser.

---

## PARTE 6 — Testar

1. Abra a URL da Vercel.
2. Clique em **Criar conta**, coloque um email e senha.
3. Faça login.
4. Cadastre uma peça e veja salvar no banco.
5. Feche o navegador, abra de novo, faça login — seus dados estão lá. ✅

---

## Como funciona a separação de usuários

Cada peça salva no banco tem um campo `user_id` que é preenchido automaticamente com o ID do usuário logado. As regras de segurança (Row Level Security) do Postgres garantem que **um usuário NUNCA consegue ler nem alterar peças de outro**, mesmo que tente trapacear no console do navegador. Isso é resolvido no banco, não no front — é o jeito certo.

---

## Atualizações de versão

### v2.1 — Data de compra por peça

Se você já tinha o app rodando antes desta atualização, precisa rodar uma migração no banco:

1. Vá no **SQL Editor** do Supabase
2. Crie uma nova query
3. Cole o conteúdo do arquivo `supabase-migration-v2.sql`
4. Clique em **Run**

Isso adiciona o campo `data_compra` na tabela. Peças antigas vão ficar com a data de hoje como default — você pode editar cada uma para ajustar a data correta.

Se está instalando **agora pela primeira vez**, ignore — o `supabase-setup.sql` já tem tudo.

---

## Atualizando o site depois

Toda vez que você atualizar arquivos no GitHub (mesmo pelo site, editando direto), a Vercel **redeploya automaticamente** em segundos. Você não precisa fazer nada além de salvar no GitHub.

---

## Limites do free tier (sossega)

- **Supabase free**: 500 MB de banco, 50.000 usuários ativos por mês, 5 GB de transferência. Para um projeto pessoal de organizar PC, você usa menos de 1% disso.
- **Vercel free**: 100 GB de transferência, deploys ilimitados. Idem.
- **GitHub free**: repositórios públicos ilimitados.

Você não vai precisar pagar nada.

---

## Problemas comuns

**"Failed to fetch" no console**: a chave do Supabase está errada ou o projeto pausou (Supabase pausa projetos free após 7 dias sem uso — basta entrar no painel e despausar).

**Login não funciona**: confira se desligou "Confirm email" no Supabase, ou se confirmou o email recebido na caixa de entrada.

**Página em branco na Vercel**: abra o Console do navegador (F12) e veja o erro. Geralmente é a chave/URL errada no `config.js`.
