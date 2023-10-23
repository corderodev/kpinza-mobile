# Kpinza Mobile

Kpinza es un software desarrollado en Python con Django y PostgreSQL que posee como objetivo ser un medio de organización de proyectos y tareas para los usuarios. Centrado principalmente en el proceso de las 3S para el desarrollo de software:

- Eficacia: Conseguir las metas establecidas.
- Eficiencia: Es la capacidad para conseguir las metas con la menor cantidad de recursos.
- Efectividad: Es evaluar si lo que se hace tiene un impacto positivo en el contexto más amplio.

Actualmente el software solo posee su versión web, por lo cual en este proyecto se busca desplegar sus funcionalidades para dispositivos móviles tanto Android como IOS mediante la tecnología Flutter.

# Clase NavigationBar

La **clase NavigationBar** es un `StatefulWidget` que representa una barra de navegación en una aplicación de Flutter. Esta barra de navegación se utiliza para alternar entre diferentes secciones o pantallas en la aplicación. Los usuarios pueden tocar los íconos en la barra de navegación para cambiar la vista actual.

## Atributos

- `currentIndex`: Un entero que representa el índice de la vista actual en la barra de navegación. Esto determina qué ícono está resaltado o seleccionado.
- `onTabTapped`: Una función de devolución de llamada que se llama cuando un ícono en la barra de navegación se toca. Esta función toma un argumento entero que representa el índice del ícono seleccionado.

## Constructor

El constructor de la clase `NavigationBar` toma los siguientes argumentos:

- `currentIndex`: El índice de la vista actual en la barra de navegación.
- `onTabTapped`: La función de devolución de llamada que se llama cuando se toca un ícono en la barra de navegación.

## Método _NavigationBarState

El método `_NavigationBarState` devuelve una instancia de la clase `_NavigationBarState`. Esta clase interna `_NavigationBarState` es la que construye la interfaz de usuario de la barra de navegación.

## Método build(BuildContext context)

El método `build` define la estructura y la apariencia de la barra de navegación. Utiliza el widget `BottomNavigationBar` para crear la barra de navegación con íconos y etiquetas. Los íconos representan diferentes vistas o secciones de la aplicación, y el `currentIndex` se utiliza para resaltar el ícono correspondiente al índice actual. Cuando un ícono se toca, se llama a la función `onTabTapped` para manejar la navegación a la vista correspondiente.

# Clase ProjectsScreen

La **clase ProjectsScreen** es un *StatefulWidget* que representa la pantalla principal de la lista de proyectos. Los usuarios pueden ver la lista de proyectos existentes y realizar diversas acciones, como agregar nuevos proyectos y acceder a la pantalla de detalles de proyectos.

## Atributos

- **projects**: Una lista de objetos **Project** que almacena información sobre los proyectos existentes.

## Métodos

- **_changeProjectName(Project project, String newName)**: Permite cambiar el nombre de un proyecto existente. Actualiza el nombre del proyecto en la lista de proyectos.
- **_createProject(String projectName)**: Permite crear un nuevo proyecto y agregarlo a la lista de proyectos.
- **_showCreateProjectForm(BuildContext context)**: Muestra un diálogo que permite al usuario crear un nuevo proyecto proporcionando un nombre.
- **_deleteProject(Project project)**: Elimina un proyecto de la lista de proyectos.

## Uso de Componentes Externos

El código importa componentes y clases externas para su funcionamiento. Estos componentes incluyen:

- **CreateProjectForm**: Un formulario que permite al usuario crear un nuevo proyecto.
- **ProjectList**: Un widget que muestra la lista de proyectos existentes.
- **Project**: Una clase que representa un proyecto.

# Clase ProjectDetailScreen

La clase `ProjectDetailScreen` es un StatefulWidget que representa la pantalla principal de la aplicación para ver y gestionar los detalles del proyecto. La pantalla muestra información sobre el proyecto, las etapas y las tareas dentro de cada etapa. Además, permite realizar diversas acciones, como editar el nombre del proyecto, agregar etapas y tareas, editar o eliminar etapas y tareas, y eliminar el proyecto en sí.

## Atributos

- `project`: Representa el proyecto actual.
- `onDelete`: Una función de devolución de llamada que se llama cuando se elimina el proyecto.
- `changeProjectName`: Una función de devolución de llamada que se llama para cambiar el nombre del proyecto.

## Métodos

- `_saveName()`: Guarda el nombre del proyecto modificado.
- `_createStage()`: Crea una nueva etapa en el proyecto.
- `_deleteStage()`: Muestra un diálogo para confirmar la eliminación de una etapa.
- `_createTask()`: Crea una nueva tarea en una etapa específica.
- `_deleteTask()`: Elimina una tarea de una etapa.
- `_showCreateStageOrTaskForm()`: Muestra un diálogo para crear una etapa o tarea.
- `_renameStage()`: Renombra una etapa.
- `_showEditStageName()`: Muestra un diálogo para editar el nombre de una etapa.
- `_showEditTaskDetails()`: Muestra un diálogo para editar los detalles de una tarea.
- `_moveTask()`: Mueve una tarea de una etapa a otra.

## Uso de Componentes Externos

El código importa componentes y clases externas para su funcionamiento. Estos componentes incluyen:

- `CreateStageOrTaskForm`: Un formulario para crear nuevas etapas o tareas.
- `Project`: Una clase que representa un proyecto.
- `Stage`: Una clase que representa una etapa en un proyecto.
- `Task`: Una clase que representa una tarea dentro de una etapa.

# Clase CreateStageOrTaskForm

La **clase CreateStageOrTaskForm** es un `StatefulWidget` que representa un formulario para crear etapas o tareas en la aplicación. Dependiendo del estado, el formulario permite al usuario ingresar información necesaria para crear una etapa o una tarea en un proyecto.

## Atributos

- `stages`: Una lista de etapas existentes en el proyecto, utilizada para seleccionar la etapa a la que se asociará una tarea.
- `onCreateStage`: Una función de devolución de llamada que se llama cuando se crea una nueva etapa.
- `onCreateTask`: Una función de devolución de llamada que se llama cuando se crea una nueva tarea. Esta función toma parámetros como el nombre de la tarea, la etapa a la que pertenece, el responsable, el estado, la fecha de inicio y la fecha de entrega.

## Método build(BuildContext context)

El método `build` define la estructura y la apariencia del formulario. Puede representar tanto la creación de una etapa como la creación de una tarea, dependiendo del estado `_isCreatingTask`. Los elementos de interfaz de usuario incluyen:

- Título del diálogo que cambia según si se está creando una etapa o una tarea.
- Campo de entrada de texto para el nombre de la etapa o la tarea.
- Campo de entrada de texto para el responsable de la tarea (visible solo al crear una tarea).
- Selección de la etapa a la que se asociará la tarea (visible solo al crear una tarea).
- Selección de la fecha de inicio y fecha de entrega (visible solo al crear una tarea).
- Botón para confirmar la creación de la etapa o tarea.

## Eventos y Acciones

- El botón "Crear Tarea" o "Crear Etapa" permite al usuario confirmar la creación de una etapa o tarea con la información proporcionada en el formulario.
- El botón "Crear Tarea" o "Crear Etapa" desencadena la llamada a la función de devolución de llamada correspondiente (`onCreateStage` o `onCreateTask`).
- El botón "Crear Etapa" o "Crear Tarea" limpia los campos de entrada después de la creación y cierra el diálogo.

## Cambio de Estado

- El botón "Crear Etapa" o "Crear Tarea" también permite cambiar entre la creación de etapas y tareas, lo que modifica la visibilidad de ciertos campos en el formulario.

## Uso de Componentes Externos

El código importa el componente `Project` para su funcionamiento. Este componente se utiliza para representar proyectos en la aplicación.

Este formulario proporciona una interfaz para la creación de etapas y tareas, lo que facilita la gestión de proyectos en la aplicación.


# CreateProjectForm Widget

El widget `CreateProjectForm` es un `StatefulWidget` que se utiliza para mostrar un formulario de creación de proyectos en una ventana emergente (`AlertDialog`). Este formulario permite a los usuarios ingresar un nombre para un nuevo proyecto.

## Constructor

- `CreateProjectForm({super.key, required this.onSubmit})`: Constructor de la clase `CreateProjectForm`. Toma una función de devolución de llamada `onSubmit` que se llama cuando el usuario envía el formulario. Requiere que se proporcione esta función. El argumento opcional `key` permite especificar una clave para identificar el widget.

## Estado (_CreateProjectFormState)

La clase `_CreateProjectFormState` representa el estado interno del widget `CreateProjectForm`. En este estado, se administra un controlador de texto para el campo de entrada del nombre del proyecto.

## Métodos

- `_build(BuildContext context)`: Método que genera la interfaz de usuario del formulario de creación de proyectos. Muestra un diálogo emergente con un campo de entrada de texto para el nombre del proyecto, un botón "Cancelar" y un botón "Crear Proyecto". Cuando se presiona el botón "Crear Proyecto", se llama a la función de devolución de llamada `onSubmit` con el nombre del proyecto ingresado por el usuario. Luego, se limpia el campo de entrada y se cierra el diálogo emergente.

# Clase Project

La **clase Project** representa un proyecto y contiene información sobre su nombre y las etapas asociadas. Cada proyecto tiene un nombre y una lista de etapas.

## Atributos

- `name` (String): El nombre del proyecto.
- `stages` (List de Stage): Una lista de etapas que pertenecen al proyecto.

## Constructor

- `Project({required this.name, List<Stage>? stages})`: Constructor de la clase Project. Recibe el nombre del proyecto (obligatorio) y una lista opcional de etapas. Si no se proporciona una lista de etapas, se inicializa como una lista vacía.

## Método copyWith

- `copyWith({String? name, List<Stage>? stages})`: Este método permite crear una copia del proyecto con la posibilidad de modificar el nombre y la lista de etapas. Devuelve un nuevo objeto Project con los valores actualizados o los mismos si no se proporcionan.

# Clase Stage

La **clase Stage** representa una etapa dentro de un proyecto y contiene información sobre su nombre y las tareas asociadas. Cada etapa tiene un nombre y una lista de tareas.

## Atributos

- `name` (String): El nombre de la etapa.
- `tasks` (List de Task): Una lista de tareas que pertenecen a la etapa.

## Constructor

- `Stage({required this.name, List<Task>? tasks})`: Constructor de la clase Stage. Recibe el nombre de la etapa (obligatorio) y una lista opcional de tareas. Si no se proporciona una lista de tareas, se inicializa como una lista vacía.

## Método copyWith

- `copyWith({String? name, List<Task>? tasks})`: Este método permite crear una copia de la etapa con la posibilidad de modificar el nombre y la lista de tareas. Devuelve un nuevo objeto Stage con los valores actualizados o los mismos si no se proporcionan.

# Clase Task

La **clase Task** representa una tarea dentro de una etapa y contiene información detallada sobre la tarea, como su nombre, responsable, estado, fecha de inicio y fecha de vencimiento.

## Atributos

- `name` (String): El nombre de la tarea.
- `responsable` (String opcional): El responsable de la tarea (puede ser nulo).
- `status` (String): El estado de la tarea (valor predeterminado: 'Pendiente').
- `startDate` (DateTime opcional): La fecha de inicio de la tarea (puede ser nulo).
- `dueDate` (DateTime opcional): La fecha de vencimiento de la tarea (puede ser nulo).

## Constructor

- `Task({required this.name, this.responsable, this.status = 'Pendiente', this.startDate, this.dueDate})`: Constructor de la clase Task. Recibe el nombre de la tarea (obligatorio) y otros atributos opcionales para configurar la tarea.

# Clase ProjectList

La **clase ProjectList** es un componente `StatelessWidget` que se utiliza para mostrar una lista de proyectos. Esta lista de proyectos se puede tocar para ver detalles adicionales o eliminar un proyecto. A continuación, se detallan sus atributos y métodos:

## Atributos

- `projects`: Una lista de proyectos que se van a mostrar en la lista.
- `onDelete`: Una función de devolución de llamada que se llama cuando se elimina un proyecto.
- `changeProjectName`: Una función de devolución de llamada que se llama para cambiar el nombre de un proyecto.

## Constructor

- `ProjectList`: El constructor de la clase que recibe los atributos mencionados anteriormente.

## Método build

El método `build` se encarga de construir la interfaz de usuario de la lista de proyectos. En resumen, realiza lo siguiente:

- Comprueba si la lista de proyectos está vacía. Si es así, muestra un mensaje indicando que no hay proyectos disponibles.
- Si la lista de proyectos no está vacía, muestra una lista desplazable (`ListView.builder`) que contiene tarjetas (`Card`) para cada proyecto. Cada tarjeta incluye el nombre del proyecto, un ícono para eliminar y la posibilidad de tocarla para ver detalles adicionales.
