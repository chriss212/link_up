import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:link_up/login/login_screen.dart';
import 'package:link_up/register/register_screen.dart';

class WelcomeScreen extends StatefulWidget { //statefull porque maneja acciones
  static const name = 'welcome';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin { //sincroniza la animacion con el refresh
  late AnimationController _controller; //tiempo de duracion
  late Animation<double> _fadeAnimation; //opacidad de la animacion
  late Animation<double> _scaleAnimation; // la escala
  late Animation<Offset> _slideAnimation;// para que suba levenmente

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), //el tiempo de la animacion
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate( //define el tramo de la animacion y la naturalidad de la onda que tan visible es 
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)), //easeout que vaya lentito
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate( //el tamano de mi widget 
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate( //entra deslizandose de abajo hacia arriba de x,y 
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic)),
    );

    _controller.forward(); //para que inicie la animacion 
  }

  @override
  void dispose() { //cuando el widget no esta pantalla lo quita
    _controller.dispose();
    super.dispose();
  }

// AQUI ESTA TODA LA ESTRUCTURA BASE DE LA PANTALLA
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity, //todo ancho posible
        height: double.infinity, //todo el alto posible
        decoration: BoxDecoration(

          //PARA EL GRADIENT
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.15),
              colorScheme.primaryContainer.withOpacity(0.1),
              theme.scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.5, 1.0], //inicio, la mitad y el final del gradient 
          ),
        ),

        child: SafeArea( //no se meta abajo del notch
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),//limita el ancho a 400 para que en otros dispositivos no se distorsione
              child: Padding(
                padding: const EdgeInsets.all(32), //espacio interno
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, //centra elementos vertical
                  crossAxisAlignment: CrossAxisAlignment.stretch, //usa todo el ancho posible
                  children: [
                    const Spacer(flex: 2),

                    // Logo animado
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation, //esto se hizo para que parecia un efecto pop del logo
                        child: Container(
                          padding: const EdgeInsets.all(24), //el espacio alrededor de la imagen
                          decoration: BoxDecoration(
                            color: theme.inputDecorationTheme.fillColor, //el color de mi tema
                            shape: BoxShape.circle,//forma circular
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.2),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),

                          // Para poner la foto del logo
                          child: Image.asset(
                            'assets/images/Linkup.png',
                            height: 120,
                            errorBuilder: (context, error, stackTrace) { //por si el asset no sirve para que no me salga feo en pantalla
                              return Icon(Icons.group_rounded, size: 120, color: colorScheme.primary); 
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40), // la sepacion del logo y el tectp

                    // Título + copy
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            Text(
                              'LinkUp',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Plan, coordinate and enjoy\nyour social adventures',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Botones
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () => context.goNamed(LoginScreen.name),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  elevation: 4,
                                  shadowColor: colorScheme.primary.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: const Text('Log In',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 56,
                              child: OutlinedButton(
                                onPressed: () => context.goNamed(RegisterScreen.name),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: colorScheme.primary,
                                  side: BorderSide(color: colorScheme.primary, width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: const Text('Register',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(flex: 1),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Connect • Plan • Celebrate',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          letterSpacing: 2,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
