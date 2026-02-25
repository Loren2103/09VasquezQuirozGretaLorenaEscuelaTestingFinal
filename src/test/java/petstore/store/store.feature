@RegresionStore
Feature: API PetStore - Módulo de Tienda (Store)

  Background:
    * url apiPetStore
    * def jsonPedido = read('classpath:petstore/data/pedido-request.json')
    * def idPedidoRandom = Math.floor(Math.random() * 9000) + 1
    * def idMascotaRandom = Math.floor(Math.random() * 90000) + 10000

  @HappyPath @CrearPedido
  Scenario: Realizar un pedido de una mascota exitosamente
    Given path 'store/order'
    * set jsonPedido.id = idPedidoRandom
    * set jsonPedido.petId = idMascotaRandom

    And request jsonPedido
    When method post
    Then status 200
    And match response.id == idPedidoRandom
    And match response.status == 'placed'

    * def idPedidoCreado = response.id

  @HappyPath @ConsultarPedido
  Scenario: Consultar un pedido existente por su ID
    * def creacionResponse = call read('store.feature@CrearPedido')
    * def idPedido = creacionResponse.idPedidoCreado

    Given path 'store/order', idPedido
    When method get
    Then status 200
    And match response.id == idPedido

  @HappyPath @ConsultarInventario
  Scenario: Consultar el inventario de mascotas por estado
    Given path 'store/inventory'
    When method get
    Then status 200
    # Validar que devuelva un objeto JSON
    And match response == '#object'

  @HappyPath @EliminarPedido
  Scenario: Eliminar un pedido existente
    * def creacionResponse = call read('store.feature@CrearPedido')
    * def idPedido = creacionResponse.idPedidoCreado

    Given path 'store/order', idPedido
    When method delete
    Then status 200
    And match response.message == idPedido + ''

  @UnhappyPath @PedidoNoEncontrado
  Scenario: Intentar consultar un pedido que no existe
    Given path 'store/order', '999999'
    When method get
    Then status 404
    And match response.message == 'Order not found'

  @UnhappyPath @EliminarPedidoNoEncontrado
  Scenario: Intentar eliminar un pedido que no existe
    Given path 'store/order', '999999'
    When method delete
    Then status 404
    And match response.message == 'Order Not Found'

  @UnhappyPath @MetodoInvalidoInventario
  Scenario: Intentar modificar el inventario usando un método no permitido
    Given path 'store/inventory'
    And request { "status": "available" }
    When method post
    # 405 Method Not Allowed
    Then status 405

  @UnhappyPath @IdPedidoLetras
  Scenario: Intentar consultar un pedido enviando letras en vez de números en el ID
    Given path 'store/order', 'texto'
    When method get
    Then status 404
    And match response.type == 'unknown'