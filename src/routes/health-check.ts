import { FastifyInstance } from "fastify";

export async function healthCheckRoute(app: FastifyInstance) {
    app.get('/health', async (request, reply) => {
        return reply.status(200).send({ message: 'OK' })
    })
}
