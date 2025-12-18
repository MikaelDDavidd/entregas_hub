import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { getAllDeliveries, createDelivery, updateDelivery, deleteDelivery, deleteAllDeliveriesByDeliveryMan } from "../models/deliveries_model.js";
import createError from "http-errors";

// Função para listar entregas com filtro opcional por entregador
export async function listDeliveries(req, res) {
  try {
    const { deliveryMan } = req.query; // Pega o query param ?deliveryMan=nome

    const deliveries = await getAllDeliveries(deliveryMan); // Filtra se tiver nome

    // Retorna a resposta com o status e os dados diretamente
    res.status(200).json({
      status: 200,
      data: deliveries,
    });
  } catch (erro) {
    console.error(erro.message);
    res.status(500).json({
      status: 500,
      error: "Erro ao listar entregas",
    });
  }
}

// Função para criar uma nova entrega
export async function postNewDelivery(req, res) {
  const newDelivery = req.body;
  try {
    const createdDelivery = await createDelivery(newDelivery);
    res.status(200).json(createdDelivery);
  } catch (erro) {
    console.error(erro.message);
    res.status(500).json({ Error: "Falha na requisição" });
  }
}

// Calcula o diretório onde o arquivo atual está localizado
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Função para upload de imagem no VPS
export const uploadProductImage = async (req, res, next) => {
  const file = req.file;

  try {
    if (!file) {
      throw new Error("Nenhum arquivo enviado.");
    }

    // Define o diretório na raiz do projeto para armazenar as imagens
    const uploadDir = path.join(__dirname, "../../uploads");

    // Verifica se o diretório 'uploads' existe, se não, cria
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }

    // Define o caminho onde a imagem será salva
    const filePath = path.join(uploadDir, file.filename);

    // Move o arquivo para o diretório uploads
    fs.renameSync(file.path, filePath);

    // Retorna a URL pública do arquivo com o nome aleatório
    // Usa a variável de ambiente ou o IP local para funcionar em dispositivos físicos
    const baseUrl = process.env.BASE_URL || 'http://192.168.100.102:3000';
    const imageUrl = `${baseUrl}/uploads/${file.filename}`;
    res.status(200).json({ url: imageUrl });
  } catch (error) {
    console.error("Erro ao salvar a imagem:", error);
    return next(createError(502, error.message));
  }
};

// Função para atualizar uma entrega
export async function updateNewDelivery(req, res) {
  const id = req.params.id;
  const filePath = path.join(__dirname, `../../uploads/${id}.png`);

  try {
    if (!fs.existsSync(filePath)) {
      throw new Error("Arquivo não encontrado.");
    }

    const imageBuffer = fs.readFileSync(filePath);
    const destName = await extractedGeminiName(imageBuffer);

    const delivery = {
      destination: destName,
      trackingCode: "",
      creationDate: "",
      imgUrl: `http://mikaeldavid.online/uploads/${id}.png`,
      alt: "",
    };

    const updatedDelivery = await updateDelivery(id, delivery);
    res.status(200).json(updatedDelivery);
  } catch (erro) {
    console.error(erro.message);
    res.status(500).json({ Error: "Falha na Requisição" });
  }
};

// Função para deletar uma entrega individual
export async function deletePackage(req, res) {
  const id = req.params.id;
  try {
    const result = await deleteDelivery(id);
    if (result.deletedCount === 0) {
      return res.status(404).json({
        status: 404,
        error: "Entrega não encontrada"
      });
    }
    res.status(200).json({
      status: 200,
      message: "Entrega deletada com sucesso"
    });
  } catch (erro) {
    console.error(erro.message);
    res.status(500).json({
      status: 500,
      error: "Erro ao deletar entrega"
    });
  }
}

// Função para deletar todas as entregas de um entregador
export async function deleteAllPackagesByDeliveryMan(req, res) {
  const { deliveryMan } = req.params;
  try {
    const result = await deleteAllDeliveriesByDeliveryMan(deliveryMan);
    res.status(200).json({
      status: 200,
      message: `${result.deletedCount} entregas deletadas com sucesso`
    });
  } catch (erro) {
    console.error(erro.message);
    res.status(500).json({
      status: 500,
      error: "Erro ao deletar entregas"
    });
  }
}

// Função para listar todos os entregadores únicos
export async function listDeliveryMen(req, res) {
  try {
    const deliveries = await getAllDeliveries();

    // Agrupa por entregador e conta as entregas
    const deliveryMenMap = {};
    deliveries.forEach(delivery => {
      const name = delivery.deliveryMan || 'Sem nome';
      if (!deliveryMenMap[name]) {
        deliveryMenMap[name] = {
          name: name,
          count: 0,
          lastDelivery: delivery.createdAt
        };
      }
      deliveryMenMap[name].count++;
      if (delivery.createdAt > deliveryMenMap[name].lastDelivery) {
        deliveryMenMap[name].lastDelivery = delivery.createdAt;
      }
    });

    const deliveryMen = Object.values(deliveryMenMap);

    res.status(200).json({
      status: 200,
      data: deliveryMen
    });
  } catch (erro) {
    console.error(erro.message);
    res.status(500).json({
      status: 500,
      error: "Erro ao listar entregadores"
    });
  }
}
