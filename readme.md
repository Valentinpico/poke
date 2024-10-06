# Pokémones Backend

Este es un proyecto de Express para administrar las rutas y los datos que se envían desde la app móvil en Flutter.

## Dependencias

Se utilizaron las siguientes dependencias para lograr crear esta API:

- **axios**:  
  Se utiliza para enviar y recibir datos desde un servidor.

- **bcryptjs**:  
  Permite almacenar contraseñas de manera segura en la base de datos

- **cors**:  
  es un mecanismo que permite controlar el acceso a recursos en un servidor desde un origen diferente al que sirvió el recurso.

- **dotenv**:  
  Facilita la gestión de configuraciones sensibles sin tener que incluirlas directamente en el código fuente.

- **express**:  
  Facilita la gestión de rutas, middleware y solicitudes HTTP, simplificando el desarrollo de aplicaciones del lado del servidor.

- **jsonwebtoken**:  
  Se utiliza para autenticar y autorizar a los usuarios, permitiendo el intercambio seguro de información entre el cliente y el servidor mediante tokens firmados.

- **mongoose**:  
  Proporciona un esquema estructurado para los datos, permitiendo interactuar con la base de datos MongoDB de manera más sencilla

## Instalación

Para que la aplicación funcione correctamente, sigue los pasos a continuación:

1. **Clona el repositorio**:

   ```bash
   git clone https://github.com/Valentinpico/poke.git
   cd pokemones-back-express
   ```

2. **Instala las dependencias**:

   Ejecuta el siguiente comando para instalar todas las dependencias necesarias:

   ```bash
   npm i o npm install
   ```

   Para iniciar el proyecto en modo desarrollo, ejecuta:

   ```bash
   npm run dev
   ```

### Configuración del entorno

En el archivo `.env`, se tendrá la siguiente información:

```
PORT=3000
MONGO_URI=mongodb+srv://kwnigpico:QweQwe@valentin.ft2ze.mongodb.net/pokemonBD
JWT_SECRET=secretKeyValetinpico
```

- **MONGO_URI**: Se puede cambiar por una propia si se desea o dejarla así; está en la nube, así que no habrá problemas.
- **JWT_SECRET**: Es una clave cualquiera para el token.

## Rutas

### Ruta principal:

- `http://localhost:3000/api` o
- `http://[ip de la PC donde se ejecuta la API]:3000/api`

### Pokémones:

- **POST**: `http://localhost:3000/api/pokemon`  
  Esta ruta es para postear un Pokémon a la lista de favoritos. El ID del usuario y los datos del Pokémon vendrán en el body con el formato que se encuentra en el archivo.
  ejemplo del `req.body`:

  ```json
  userId: "67006f45a6332289de7245a4",
  pokemonFront: {
  name: "bulbasaur",
  id: 3,
  species: {
    url: "https://pokeapi.co/api/v2/pokemon-species/1/",
  },
  evolution_chain: {
    url: "https://pokeapi.co/api/v2/evolution-chain/1/",
  },
  sprites: {
    front_default:
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
  },
  stats: [
    {
      base_stat: 45,
      effort: 0,
      stat: {
        name: "hp",
        url: "https://pokeapi.co/api/v2/stat/1/",
      },
    },
    {
      base_stat: 49,
      effort: 0,
      stat: {
        name: "attack",
        url: "https://pokeapi.co/api/v2/stat/2/",
      },
    },
    {
      base_stat: 49,
      effort: 0,
      stat: {
        name: "defense",
        url: "https://pokeapi.co/api/v2/stat/3/",
      },
    },
    {
      base_stat: 65,
      effort: 1,
      stat: {
        name: "special-attack",
        url: "https://pokeapi.co/api/v2/stat/4/",
      },
    },
    {
      base_stat: 65,
      effort: 0,
      stat: {
        name: "special-defense",
        url: "https://pokeapi.co/api/v2/stat/5/",
      },
    },
    {
      base_stat: 45,
      effort: 0,
      stat: {
        name: "speed",
        url: "https://pokeapi.co/api/v2/stat/6/",
      },
    },
  ],
  abilities: [
    {
      ability: {
        name: "overgrow",
        url: "https://pokeapi.co/api/v2/ability/65/",
      },
      is_hidden: false,
      slot: 1,
    },
    {
      ability: {
        name: "chlorophyll",
        url: "https://pokeapi.co/api/v2/ability/34/",
      },
      is_hidden: true,
      slot: 3,
    },
  ],
  types: [
    {
      slot: 1,
      type: {
        name: "grass",
        url: "https://pokeapi.co/api/v2/type/12/",
      },
    },
    {
      slot: 2,
      type: {
        name: "poison",
        url: "https://pokeapi.co/api/v2/type/4/",
      },
    },
  ],
  }


  ```

- **GET**: `http://localhost:3000/api/pokemon/:id`  
  Esta ruta es para recuperar los Pokémones favoritos de un usuario. El ID de usuario viene en el path y se recupera con `req.params`. Este es un ejemplo:

  ```
  http://localhost:3000/api/pokemon/67020aaee1525e52b30a9665 // ID de MongoDB
  ```

- **PUT**: `http://localhost:3000/api/pokemon/:userId/:pokemonId`  
  Esta ruta es para actualizar un Pokémon o evolucionarlo. Recibe el ID de usuario e ID de Pokémon por path. Este es un ejemplo:

  ```
  http://localhost:3000/api/pokemon/67020aaee1525e52b30a9665/12 // ID de MongoDB e ID del modelo de Pokémon (entero)
  ```

- **DELETE**: `http://localhost:3000/api/pokemon`  
  Esta ruta recibe un ID de MongoDB por el path para eliminar un registro del modelo de Pokémon. Ejemplo:
  ```
  http://localhost:3000/api/pokemon/67020aaee1525e52b30a9665 // ID de MongoDB
  ```

**Nota:** Todas las rutas para los Pokémones están protegidas. Es decir, si el token ya expiró o no tiene token de autenticación, la petición no podrá pasar al middleware.

### Usuarios:

- **POST**: `http://localhost:3000/api/user`  
  Esta ruta se usa para registrar un usuario. Recibe los datos por el `req.body` y es de este formato:

  ```json
  {
    "name": "valentin",
    "email": "valentin@gmail.com",
    "password": "123"
  }
  ```

  Se crea el usuario y se guarda con la contraseña encriptada en MongoDB.

- **POST**: `http://localhost:3000/api/user/login`  
  Esta ruta para el login recibe email y contraseña para que sea comparado por el controlador y posteriormente regresar un token al usuario para que se pueda autenticar.
