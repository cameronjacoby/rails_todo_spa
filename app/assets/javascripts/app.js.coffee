# definte app and dependencies
ToDoApp = angular.module "ToDoApp", ["ngRoute", "templates"]

# set up angular router
ToDoApp.config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->
  $routeProvider
    .when "/",
      templateUrl: "index.html",
      controller: "ToDosCtrl"
    .when "/to_dos/:id",
      templateUrl: "show.html",
      controller: "ShowCtrl"
  .otherwise
    redirectTo: "/"

  $locationProvider.html5Mode(true)
]

ToDoApp.controller "ToDosCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.toDos = []

  $scope.getToDos = ->
    $scope.doneColor = {}
    $scope.doneText = {}
    $http.get("/to_dos.json").success (data) ->
      $scope.toDos = data

  $scope.getToDos()

  $scope.addToDo = (newToDo) ->
    newToDo.done = false
    $http.post("/to_dos.json", newToDo).success (data) ->
      # make newToDo object empty
      $scope.newToDo = {}
      # add ToDo to ToDos array
      $scope.toDos.push(data)

  $scope.markDone = (toDo) ->
    if !toDo.done
      toDo.done = true
      this.doneColor = "#EAEAEA"
      this.doneText = "line-through"
    else
      toDo.done = false
      this.doneColor = undefined
      this.doneText = undefined
    $http.put("/to_dos/#{this.toDo.id}.json", toDo).success (data) ->

  $scope.deleteToDo = (toDo) ->
    conf = confirm "Are you sure you want to delete this task?"
    if conf
      $http.delete("/to_dos/#{toDo.id}.json").success (data) ->
        $scope.toDos.splice($scope.toDos.indexOf(toDo), 1)

  $scope.showEditForm = ->
    this.hideToDo = true

  $scope.editToDo = (toDo) ->
    this.hideToDo = false
    $http.put("/to_dos/#{this.toDo.id}.json", toDo).success (data) ->

]

ToDoApp.controller "ShowCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.showToDo = ->
    $http.get("/to_dos/:id.json").success (data) ->
      $scope.toDo = data
      console.log($scope.toDo)

  $scope.showToDo()

]

ToDoApp.filter 'formatToDo', ->
  (done) ->
    if done
      this.doneColor = "#EAEAEA"
      this.doneText = "line-through"

# define config for CSRF token
ToDoApp.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
]