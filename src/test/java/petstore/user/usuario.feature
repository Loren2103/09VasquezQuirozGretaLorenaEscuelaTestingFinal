@RegresionUser
Feature: Automatizar modulo User de PetStore

  Background:
    * url apiPetStore
    * def jsonUsuario = read('classpath:petstore/data/usuario-request.json')
    * def randomId = Math.floor(Math.random() * 90000) + 10000
    * def nombreUsuario = 'user_' + randomId

  @HappyPath @CrearUsuario
  Scenario: Crear un usuario exitosamente sin exponer la contraseña
    Given path 'user'
    * set jsonUsuario.id = randomId
    * set jsonUsuario.username = nombreUsuario
    * set jsonUsuario.password = passwordUsuario

    And request jsonUsuario
    When method post
    Then status 200
    And match response.message == randomId+ ''

    * def username = nombreUsuario
    * def password = passwordUsuario

  @HappyPath @LoginUsuario
  Scenario: Hacer login exitoso con el usuario creado
    * def creacionResponse = call read('usuario.feature@CrearUsuario')

    Given path 'user/login'
    And param username = creacionResponse.username
    And param password = creacionResponse.password
    When method get
    Then status 200
    And match response.message contains 'logged in user session'

  @HappyPath @ConsultarUsuario
  Scenario: Consultar los datos de un usuario por su username
    * def creacionResponse = call read('usuario.feature@CrearUsuario')
    * def usuario = creacionResponse.username

    Given path 'user', usuario
    When method get
    Then status 200
    And match response.username == usuario

  @HappyPath @ActualizarUsuario
  Scenario: Actualizar los datos de un usuario existente
    * def creacionResponse = call read('usuario.feature@CrearUsuario')
    * def usuario = creacionResponse.username

    Given path 'user', usuario
    * set jsonUsuario.id = creacionResponse.randomId
    * set jsonUsuario.firstName = 'NombreActualizado'
    * set jsonUsuario.phone = '000000000'

    And request jsonUsuario
    When method put
    Then status 200
    And match response.message == creacionResponse.randomId + ''

  @HappyPath @EliminarUsuario
  Scenario: Eliminar un usuario existente
    * def creacionResponse = call read('usuario.feature@CrearUsuario')
    * def usuario = creacionResponse.username

    Given path 'user', usuario
    When method delete
    Then status 200
    And match response.message == usuario

  @HappyPath @LogoutUsuario
  Scenario: Cerrar la sesión del usuario
    Given path 'user/logout'
    When method get
    Then status 200
    And match response.message == 'ok'

  @UnhappyPath @UsuarioNoEncontrado
  Scenario: Intentar consultar un usuario que no existe
    Given path 'user', 'usuarioInexistente123'
    When method get
    Then status 404
    And match response.message == 'User not found'

  @UnhappyPath @EliminarUsuarioNoEncontrado
  Scenario: Intentar eliminar un usuario que no existe
    Given path 'user', 'usuarioInexistente123'
    When method delete
    Then status 404

  @UnhappyPath @MetodoInvalidoUsuario
  Scenario: Usar un método HTTP no permitido para consultar un usuario
    Given path 'user', 'usuarioCualquiera'
    And request {}
    When method post
    # 405 Method Not Allowed
    Then status 405