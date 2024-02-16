import 'package:farmacofy/BBDD/bbdd.dart';
import 'package:farmacofy/inicioSesion/pantallaLogin.dart';
import 'package:farmacofy/models/usuario.dart';
import 'package:farmacofy/pages/page_editar_usuario.dart';
import 'package:farmacofy/pages/page_listado_tratamientos.dart';
import 'package:farmacofy/pages/page_nuevo_usuario.dart';
import 'package:farmacofy/pages/page_tratamiento.dart';
import 'package:farmacofy/pages/page_listado_local_api.dart';
import 'package:farmacofy/presentacion/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
 
class ListadoUsuarios extends StatefulWidget {
  const ListadoUsuarios({super.key});
 
  @override
  State<ListadoUsuarios> createState() => _ListadoUsuariosState();
}
 
class IdUsuarioSeleccionado with ChangeNotifier {
  int _idUsuario = 0;
 
  int get idUsuario => _idUsuario;
 
  void setIdUsuario(int id) {
    _idUsuario = id;
    notifyListeners();
  }
}
 
class _ListadoUsuariosState extends State<ListadoUsuarios> {
  @override
  Widget build(BuildContext context) {
    // Obtener el id del usuario del proveedor
 
    final usuarioProvider = context.read<IdSupervisor>();
    final int idAdministrador = usuarioProvider.idUsuario;
 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        backgroundColor: const Color(0xFF02A724),
        flexibleSpace: Container(
          //Sirve para definir el color de la barra de estado
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF02A724),
                Color.fromARGB(255, 18, 240, 63),
                Color.fromARGB(255, 11, 134, 34),
              ],
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Acción para el botón de configuración
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      drawer: MenuDrawer(), // Agrega el Drawer aquí
 
      body: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: BaseDeDatos.consultarUsuariosPorIdAdministrador(
                idAdministrador),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Mientras espera la respuesta de la BD muestra un indicador de carga
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // Al pulsar sobre una tarjeta de usuario nos lleva a tratamientos de ese usuario
                        onTap: () {
 
                          // Guardar el ID del usuario en el Provider
                          final usuarioId = snapshot.data![index]['id'] as int;
                          Provider.of<IdUsuarioSeleccionado>(context, listen: false).setIdUsuario(usuarioId);
 
                          final esAdmin=BaseDeDatos.obtenerRolAdministrador(usuarioId);
 
                       
 
                          ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'ID Usuario: $usuarioId'),
                      ),
                    );
 
                          // Navegar a la pantalla de detalle del usuario
 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListadoTratamientos()),
                          );
                         
                        },
                        //Separacion entre las tarjetas
                        // margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                        child: ListTile(
                          leading: Icon(
                            FontAwesomeIcons.hospitalUser,
                            color: Colors.blue,
                            size: 40.0,
                          ),
                          title: Text(
                            snapshot.data![index]['nombre'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data![index]['usuario'],
                                style: TextStyle(
                                    color: Color.fromARGB(255, 12, 42, 173),
                                    fontSize: 15.0),
                              ),
                              Text(
                                'Contraseña: ' +
                                    snapshot.data![index]['contrasena'],
                                style: TextStyle(
                                    color: Color.fromARGB(255, 4, 167, 12),
                                    fontSize: 17.0),
                              ), // Añade la hora aquí
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // Aquí agregamos la lógica para editar el usuario
                                  // Guardar el ID del usuario en el Provider
                          final usuarioId = snapshot.data![index]['id'] as int;
                          Provider.of<IdUsuarioSeleccionado>(context,
                                  listen: false)
                              .setIdUsuario(usuarioId);
                          // bool esAdmin=Provider.of<AdminProvider>(context, listen: false).actualizarEsAdmin(false);
                          // Actualizar el ID del usuario seleccionado
                          Usuario usuarioSeleccionado = Usuario();
                          usuarioSeleccionado.id = snapshot.data![index]['id'];
                          Usuario usuarioNombre = Usuario();
                          usuarioNombre.nombre =
                              snapshot.data![index]['nombre'];
                          Usuario usuarioUsuario = Usuario();
                          usuarioUsuario.usuario =
                              snapshot.data![index]['usuario'];
                          Usuario usuarioContrasena = Usuario();
                          usuarioContrasena.contrasena =
                              snapshot.data![index]['contrasena'];
                          Usuario usuarioAdministrador = Usuario();
                          usuarioAdministrador.administrador =
                              snapshot.data![index]['administrador'] as int == 1
                                  ? true
                                  : false;
                          Usuario usuarioIdAdministrador = Usuario();
                          usuarioIdAdministrador.idAdministrador =
                              snapshot.data![index]['id_administrador'];
 
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('ID Usuario: $usuarioId'),
                            ),
                          );
 
                          // Navegar a la pantalla de detalle del usuario
 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditarUsuario(
                                    usuarioSeleccionado: usuarioSeleccionado,
                                    usuarioNombre: usuarioNombre,
                                    usuarioUsuario: usuarioUsuario,
                                    usuarioContrasena: usuarioContrasena,
                                    usuarioAdministrador: usuarioAdministrador,
                                    usuarioIdAdministrador:
                                    usuarioIdAdministrador)),
                          );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Aquí agregamos la lógica para eliminar el usuario
                                  showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Eliminar la consulta médica'),
                                    content:  Text(
                                        '¿Estás seguro de eliminar a este usuario ?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Aceptar'),
                                        onPressed: () {
                                          // Aquí va tu código para eliminar la consulta de la base de datos
                                          BaseDeDatos.eliminarBD('Usuarios', snapshot.data![index]['id']);
                                         
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            },
          ),
        ],
      ),
 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AnadirUsuario()),
          );
        },
        child: const Icon(Icons.person_add),
        backgroundColor: const Color(0xFF02A724),
      ),
    );
  }
}