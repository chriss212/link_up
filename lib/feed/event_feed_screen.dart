import 'package:flutter/material.dart'; //me importa todos los widgets, appbar, listview etd
import 'package:go_router/go_router.dart'; //para la navegacion
import 'package:link_up/events/new_events_screen.dart'; //para ir a la pantalla de nuevo evento

class EventFeedScreen extends StatefulWidget { //es una pantalla con estado
  static const name = 'feed';
  const EventFeedScreen({super.key});

  @override 
  State<EventFeedScreen> createState() => _EventFeedScreenState();
}
// MOCK DE EVENTOS QUEMADOS
class _EventFeedScreenState extends State<EventFeedScreen> {
  final List<_EventItem> _events = [
    _EventItem(
      title: 'ROATAN 2026', //todos los atributos de mis cards de eventos
      fecha: 'Saturday, July 20',
      DiasFaltantes: 'In 3 days',
      foto_evento: 'assets/images/roatan1.jpeg',
    ),
    _EventItem(
      title: 'fiesta Camila',
      fecha: 'Saturday, Aug 3',
      DiasFaltantes: 'In 2 weeks',
      foto_evento: 'assets/images/fiesta.jpeg',
    ),
    _EventItem(
      title: 'Hicking',
      fecha: 'Saturday, Aug 10',
      DiasFaltantes: 'In 3 weeks',
      foto_evento: 'assets/images/salidita.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold( //hace la estructura base de la pantalla
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar( //la barrita de arriha
        elevation: 0,// no tenga sombra
        backgroundColor: Colors.white, //fondo blanco
        foregroundColor: Colors.black87, //color de icons y texto negro
        centerTitle: true, //centrado
        title: const Text(
          'Events',
          style: TextStyle(
            fontWeight: FontWeight.w600, //que tan gruesa la letra es
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        actions: [
          Container( //container donde esta mi lupita
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8), //EdgeInset agrega padding solo a los lados que quise. 
            decoration: BoxDecoration( //decoracion de mi lupita
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(Icons.search_outlined, color: Colors.grey.shade600), //defino mi icon
              onPressed: () {},//ahorita la accion no hace nada
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: _events.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return _EventCard(item: _events[index]);
    },
  ),
),
      
      //Para el icono de mas en la pantalla
      floatingActionButton: SizedBox( // tamaño de la cajita
        width: 56,
        height: 56,
        child: FloatingActionButton( //flutter me lo pone ya en el ladito por estar adentro del scaffold
          onPressed: () {
            context.goNamed(NewEventScreen.name); // la ruta que me lleva al darle click
          },
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          elevation: 2, 
          child: const Icon(Icons.add, size: 24), //muestra el +
        ),
      ),
    );
  }
}

//Modelo de como se tienen que ver mis cards de los eventos, con los atributos 
class _EventItem {
  final String title;
  final String fecha;
  final String DiasFaltantes;
  final String foto_evento;

  _EventItem({
    required this.title,
    required this.fecha,
    required this.DiasFaltantes,
    required this.foto_evento,
  });
}

class _EventCard extends StatelessWidget {
  final _EventItem item; //lo que guarda mi info
  const _EventCard({required this.item});

  @override //aqui va como yo quiero que se vea la cajita donde estan todos mis eventos
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell( //ANIMACION para que se haga clickeable toda la tarjeta
        borderRadius: BorderRadius.circular(16), // no se salga la animacion de los bordes
        onTap: () { // esta vacio pero puede navegar


        },
        child: Column( //organiza en vertical los elementos 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect( //redondea mis fotos que combinen con el marco
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),

              // ve los temas de las fotos
              child: Image.asset(
                item.foto_evento,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover, //para que no se distorsione
                
                //TODO ESTO ES SI LA APP NO CARGA LAS FOTOS SALE ESO
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.grey.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Image not found',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // TODO LO DEL CONTENIDO DE MIS CARDS
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //alinea a la izquierda
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon( //MI ICONS DE CALNEDARIO
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.fecha,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.DiasFaltantes,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Estos son los 3 circulitos que representas las personas 
                          Stack(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade400,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Center(
                                  child: Text(
                                    'A',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Center(
                                  child: Text(
                                    'B',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 40),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade400,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Center(
                                  child: Text(
                                    '+3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}