import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'LinkUp',
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFFFEB7A6),
    ),
    home: const FinancesScreen(), 
  );
}

}

class FinancesScreen extends StatelessWidget {
  const FinancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffefaf4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xfffefaf4),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text("Finances",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,

      ),body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Overview",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Total Spent",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      Text("\$1,250.00",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("You Paid",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      Text("\$500.00",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.4,
                    minHeight: 8,
                    color: Colors.orange,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Still Due",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {},
                        child: const Text("Settle Up",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text("Payment Requests",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _paymentRequestCard(
              icon: Icons.close,
              color: Colors.red,
              title: "Dinner",
              subtitle: "Requested by Liam",
              amount: "\$250",
              status: "Unpaid",
              statusColor: Colors.red,
            ),
            const SizedBox(height: 12),
            _paymentRequestCard(
              icon: Icons.check_circle,
              color: Colors.green,
              title: "Hotel",
              subtitle: "Requested by Olivia",
              amount: "\$1,000",
              status: "Paid",
              statusColor: Colors.green,
            ),

            const SizedBox(height: 24),

            const Text("Split Expenses",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _splitExpenseCard(
              icon: Icons.directions_bus,
              color: Colors.orange,
              title: "Transportation",
              subtitle: "Split with 4 people",
              amount: "\$500",
            ),
            const SizedBox(height: 12),
            _splitExpenseCard(
              icon: Icons.sports_soccer,
              color: Colors.green,
              title: "Activities",
              subtitle: "Split with 4 people",
              amount: "\$750",
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 0,
  type: BottomNavigationBarType.fixed,
  selectedItemColor: Colors.orange,
  unselectedItemColor: Colors.grey,
  onTap: (index) {
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  },
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
    BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 32), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ],
),

    );
  }

  Widget _paymentRequestCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String amount,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(status,
                  style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ],
          )
        ],
      ),
    );
  }

  Widget _splitExpenseCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          Text(amount,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffefaf4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xfffefaf4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
         
            Column(
              children: const [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=47", 
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Sophia Bennett",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 4),
                Text(
                  "@sophia.b",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
              ],
            ),

            
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    children: [
      ListTile(
  leading: const Icon(Icons.person, color: Colors.blue),
  title: const Text("Personal Information"),
  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const EditPersonalInfoScreen()),
  );
},

),

      const Divider(height: 1),
      ListTile(
        leading: const Icon(Icons.notifications, color: Colors.blue),
        title: const Text("Notifications"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NotificationsScreen()),
          );
        },
      ),
    ],
  ),
),
const SizedBox(height: 20),


Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  ),
  child: ListTile(
    leading: const Icon(Icons.history, color: Colors.blue),
    title: const Text("Past Events"),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const PastEventsScreen()),
      );
    },
  ),
),
const SizedBox(height: 20),


Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  ),
  child: ListTile(
    leading: const Icon(Icons.logout, color: Colors.red),
    title: const Text(
      "Log Out",
      style: TextStyle(color: Colors.red),
    ),
    onTap: () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const FinancesScreen()),
        (route) => false,
      );
    },
  ),
),

Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  ),
  child: ListTile(
    leading: const Icon(Icons.account_balance_wallet, color: Colors.orange),
    title: const Text("Finanzas"),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FinancesScreen()),
      );
    },
  ),
),
const SizedBox(height: 20),

           
          ],
        ),
      ),
    );
  }

  
}

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffefaf4),
      appBar: AppBar(
        backgroundColor: const Color(0xfffefaf4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Personal Information",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Here you can edit your personal information.",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffefaf4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xfffefaf4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.notifications_active,
                    color: Colors.orange, size: 28),
                SizedBox(width: 10),
                Text(
                  "Latest Updates",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),

         
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Row(
                children: [
                
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    child: const Icon(Icons.flight_takeoff,
                        color: Colors.orange, size: 28),
                  ),
                  const SizedBox(width: 12),

               
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Upcoming Trip",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Tu próximo viaje será el día 21 de octubre hacia Tamaulipas, México ✈️🌎",
                          style:
                              TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

          
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade200, Colors.orange.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lightbulb, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Consejo: prepara tu maleta con 2 días de anticipación y revisa tu pasaporte ✨",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
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


class PastEventsScreen extends StatelessWidget {
  const PastEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffefaf4),
      appBar: AppBar(
        backgroundColor: const Color(0xfffefaf4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Past Trips",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tripCard(
            flagUrl: "https://flagcdn.com/w40/sv.png",
            title: "Cuscatancingo, El Salvador 🇸🇻",
            date: "12 de marzo, 2023",
            description: "Un viaje cultural lleno de historia y tradiciones.",
          ),
          const SizedBox(height: 16),
          _tripCard(
            flagUrl: "https://flagcdn.com/w40/pf.png", 
            title: "Bora Bora, Polinesia Francesa 🏝️",
            date: "5 de agosto, 2023",
            description: "Playas paradisíacas y aguas cristalinas inolvidables.",
          ),
          const SizedBox(height: 16),
          _tripCard(
            flagUrl: "https://flagcdn.com/w40/ss.png", 
            title: "Sudán del Sur 🇸🇸",
            date: "21 de enero, 2024",
            description: "Una experiencia única explorando lo desconocido.",
          ),
        ],
      ),
    );
  }

  
  Widget _tripCard({
    required String flagUrl,
    required String title,
    required String date,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(flagUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(date,
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 8),
                Text(description,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class EditPersonalInfoScreen extends StatefulWidget {
  const EditPersonalInfoScreen({super.key});

  @override
  State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final TextEditingController _nameController =
      TextEditingController(text: "Sophia Bennett");
  final TextEditingController _usernameController =
      TextEditingController(text: "@sophia.b");
  final TextEditingController _emailController =
      TextEditingController(text: "sophia@email.com");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffefaf4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xfffefaf4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar con botón de cámara
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage("https://i.pravatar.cc/150?img=47"),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Nombre
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: const Icon(Icons.person, color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Name cannot be empty" : null,
              ),
              const SizedBox(height: 16),

              // Username
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.alternate_email,
                      color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Username cannot be empty" : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email, color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value!.contains("@") ? null : "Enter a valid email",
              ),
              const SizedBox(height: 24),

              // Botón Guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profile updated successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


