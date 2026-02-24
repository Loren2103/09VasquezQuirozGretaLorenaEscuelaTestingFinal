@RegresionPet
Feature: Automatizar modulo Pet de PetStore

  Background:
    * url apiPetStore
    * def jsonPet = read('classpath:petstore/data/pet-request.json')

  @HappyPath @CrearMascota
  Scenario: Verificar creacion de una mascota exitosamente
    Given path 'pet'
    * def randomId = Math.floor(Math.random() * 90000) + 10000
    * set jsonPet.id = randomId

    And request jsonPet
    When method post
    Then status 200
    And match response.id == randomId

    * def idMascotaCreada = response.id

  @HappyPath @ConsultarMascota
  Scenario: Consultar una mascota existente por su ID
    * def creacionResponse = call read('pet.feature@CrearMascota')
    * def idMascota = creacionResponse.idMascotaCreada

    Given path 'pet', idMascota
    When method get
    Then status 200
    And match response.id == idMascota
    And match response.status == 'available'

  @HappyPath @ActualizarMascota
  Scenario: Actualizar el estado de una mascota a 'sold'
    * def creacionResponse = call read('pet.feature@CrearMascota')
    * def idMascota = creacionResponse.idMascotaCreada

    Given path 'pet'
    * set jsonPet.id = idMascota
    * set jsonPet.status = 'sold'
    And request jsonPet
    When method put
    Then status 200
    And match response.status == 'sold'

  @HappyPath @BuscarPorEstado
  Scenario Outline: Buscar mascotas filtrando por sus diferentes estados
    Given path 'pet/findByStatus'
    And param status = '<estado>'
    When method get
    Then status 200
    # Validar que la respuesta sea un arreglo (lista)
    And match response == '#[]'

    Examples:
      | estado    |
      | available |
      | pending   |
      | sold      |

  @HappyPath @EliminarMascota
  Scenario: Eliminar una mascota existente
    * def creacionResponse = call read('pet.feature@CrearMascota')
    * def idMascota = creacionResponse.idMascotaCreada

    Given path 'pet', idMascota
    When method delete
    Then status 200

  @HappyPath @SubirImagen
  Scenario: Subir una imagen de la mascota
    * def creacionResponse = call read('pet.feature@CrearMascota')
    * def idMascota = creacionResponse.idMascotaCreada

    Given path 'pet', idMascota, 'uploadImage'
    And multipart file file = { read: 'classpath:petstore/data/perrito.jpg', filename: 'perrito.jpg', contentType: 'image/jpeg' }
    When method post
    Then status 200
    And match response.message contains 'perrito.jpg'

  @UnhappyPath @MascotaNoEncontrada
  Scenario: Intentar consultar una mascota que no existe
    Given path 'pet', '9999999999999999'
    When method get
    Then status 404
    And match response.type == 'error'
    And match response.message == 'Pet not found'

  @UnhappyPath @MetodoInvalido
  Scenario: Intentar crear una mascota usando un método HTTP incorrecto (GET en vez de POST)
    Given path 'pet'
    And request jsonPet
    When method get
    # 405 Method Not Allowed
    Then status 405

  @UnhappyPath @EliminarMascotaNoExistente
  Scenario: Intentar eliminar una mascota que no existe
    Given path 'pet', '9999999999999999'
    When method delete
    Then status 404

  @UnhappyPath @IdInvalido
  Scenario: Intentar consultar una mascota enviando letras en vez de números en el ID
    Given path 'pet', 'textoInvalido'
    When method get
    Then status 404
    And match response.type == 'unknown'

  @UnhappyPath @BuscarEstadoInvalido
  Scenario: Buscar mascotas usando un estado que no existe
    Given path 'pet/findByStatus'
    And param status = 'estadoInvalido'
    When method get
    Then status 200
    And match response == '#[0]'
