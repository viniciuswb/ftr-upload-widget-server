import { log } from "../infra/logger";
import { FastifyInstance } from "fastify";

export async function healthCheckRoute(app: FastifyInstance) {
    app.get('/health', async (request, reply) => {
        log.info("Application running successfully")
        return reply.status(200).send({ message: 'OK' })
    })
}
