# definte app and dependencies
ToDoApp = angular.module "ToDoApp", ["ngRoute", "templates"]

# set up angular router
ToDoApp.config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->
  $routeProvider
    .when "/",
      templateUrl: "index.html",
      controller: "ToDosCtrl"
  .otherwise
    redirectTo: "/"

  $locationProvider.html5Mode(true)
]

ToDoApp.controller "ToDosCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.toDos = []

  $scope.getToDos = ->
    $http.get("/to_dos.json").success (data) ->
      $scope.toDos = data

  $scope.getToDos()

  $scope.addToDo = ->
    $http.post("/to_dos.json", $scope.newToDo).success (data) ->
      # make newToDo object empty
      $scope.newToDo = {}
      # add ToDo to ToDos array
      $scope.toDos.push(data)

  $scope.markDone = (toDo) ->
    toDo.done = true
    $http.put("/to_dos/#{this.toDo.id}.json", toDo).success (data) ->
    # if !this.doneText
    #   this.doneText = "line-through"
    #   this.doneColor = "#EAEAEA"
    # else
    #   this.doneText = undefined
    #   this.doneColor = undefined

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

# define config for CSRF token
ToDoApp.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
]