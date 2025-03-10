const functions = require("firebase-functions");
const express = require("express");
const admin = require("firebase-admin");
const { Storage } = require("@google-cloud/storage");
const cors = require("cors");
const bodyParser = require("body-parser");

admin.initializeApp({
  databaseURL: "https://entrega-hub-entregas.firebaseio.com"
});

const storage = new Storage();
const app = express();

// Configurar os middlewares
app.use(cors({ origin: true }));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Endpoint para listar encomendas
app.get("/encomendas", async (req, res) => {
  try {
    const snapshot = await admin.database().ref("/encomendas").once("value");
    res.json(snapshot.val());
  } catch (error) {
    console.error("Erro ao buscar encomendas:", error);
    res.status(500).send("Erro ao buscar encomendas.");
  }
});

// Endpoint para criar uma nova encomenda
app.post("/encomendas", async (req, res) => {
  try {
    const novaEncomenda = req.body;

    // Validar os dados recebidos (opcional)
    if (!novaEncomenda.data || !novaEncomenda.hora || !novaEncomenda.id ||
      !novaEncomenda.codigoRastreio || !novaEncomenda.entregador ||
      !novaEncomenda.imagemUrl) {
      return res.status(400).send("Dados da encomenda inválidos.");
    }

    // Usar ID fornecido na requisição
    const encomendaId = novaEncomenda.id;
    await admin.database().ref(`/encomendas/${encomendaId}`).set(novaEncomenda);
    res.status(201).json({ id: encomendaId });
  } catch (error) {
    console.error("Erro ao criar encomenda:", error);
    res.status(500).send("Erro ao criar encomenda.");
  }
});

// Endpoint para buscar uma encomenda pelo ID
app.get("/encomendas/:id", async (req, res) => {
  try {
    const encomendaId = req.params.id;
    const snapshot = await admin.database().ref(`/encomendas/${encomendaId}`).once("value");
    if (snapshot.exists()) {
      res.json(snapshot.val());
    } else {
      res.status(404).send("Encomenda não encontrada.");
    }
  } catch (error) {
    console.error("Erro ao buscar encomenda:", error);
    res.status(500).send("Erro ao buscar encomenda.");
  }
});

// Endpoint para atualizar uma encomenda
app.put("/encomendas/:id", async (req, res) => {
  try {
    const encomendaId = req.params.id;
    const dadosAtualizados = req.body;

    // Validação de dados
    if (!dadosAtualizados || Object.keys(dadosAtualizados).length === 0) {
      return res.status(400).send("Dados da atualização inválidos.");
    }

    await admin.database().ref(`/encomendas/${encomendaId}`).update(dadosAtualizados);
    console.log(`Encomenda ${encomendaId} atualizada com sucesso.`);
    res.send("Encomenda atualizada com sucesso.");
  } catch (error) {
    console.error(`Erro ao atualizar encomenda ${encomendaId}:`, error);
    res.status(500).send("Erro ao atualizar encomenda.");
  }
});

// Endpoint para deletar uma encomenda
app.delete("/encomendas/:id", async (req, res) => {
  try {
    const encomendaId = req.params.id;
    await admin.database().ref(`/encomendas/${encomendaId}`).remove();
    console.log(`Encomenda ${encomendaId} removida com sucesso.`);
    res.send("Encomenda removida com sucesso.");
  } catch (error) {
    console.error(`Erro ao remover encomenda ${encomendaId}:`, error);
    res.status(500).send("Erro ao remover encomenda.");
  }
});

// Endpoint para fazer upload de uma imagem
app.post("/upload", async (req, res) => {
  try {
    if (!req.files || !req.files.imagem) {
      return res.status(400).send("Nenhuma imagem enviada.");
    }

    const imagem = req.files.imagem;
    const nomeArquivo = `${Date.now()}-${imagem.name}`;
    const bucket = storage.bucket("entrega-hub.appspot.com");
    const arquivo = bucket.file(nomeArquivo);

    const stream = arquivo.createWriteStream({
      metadata: {
        contentType: imagem.mimetype,
      },
    });

    stream.on("error", (error) => {
      console.error(`Erro ao fazer upload da imagem ${nomeArquivo}:`, error);
      res.status(500).send("Erro ao fazer upload da imagem.");
    });

    stream.on("finish", () => {
      console.log(`Imagem ${nomeArquivo} enviada com sucesso.`);
      res.status(201).send(`Imagem enviada com sucesso. URL: ${arquivo.publicUrl()}`);
    });

    stream.end(imagem.data);
  } catch (error) {
    console.error("Erro ao fazer upload da imagem:", error);
    res.status(500).send("Erro ao fazer upload da imagem.");
  }
});

exports.testStorage = functions.https.onCall(async (data, context) => {
  try {
    const bucket = storage.bucket('entrega-hub.appspot.com');
    const [files] = await bucket.getFiles();
    console.log('Arquivos no bucket:');
    files.forEach(file => {
      console.log(file.name);
    });
    return "Acesso ao Storage OK";
  } catch (error) {
    console.error('Erro ao acessar o Storage:', error);
    return "Erro ao acessar o Storage";
  }
});

exports.api = functions.https.onRequest(app);