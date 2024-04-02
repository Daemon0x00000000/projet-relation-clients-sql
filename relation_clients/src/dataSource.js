import postgres from "postgres";

const dataSource = postgres({
    host: "localhost",
    port: 5432,
    database: "postgres",
    username: "admin",
    password: "admin",
})

export default dataSource;