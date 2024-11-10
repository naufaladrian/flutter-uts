import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uts_genap/modal/item.dart';
import 'package:uts_genap/screens/payment_screen.dart';
import 'package:uts_genap/screens/update_credentials_screen.dart';
import 'package:uts_genap/widgets/gapped.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<DashboardScreen> {
  int totalHarga = 0;
  List<Item> purchasedItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void resetTotal() {
    setState(() {
      totalHarga = 0;
      purchasedItems.clear();
    });
  }

  void updateTotal(Item item) {
    setState(() {
      totalHarga += item.price;
      purchasedItems.add(item);
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // hapus status login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warung Ajib"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Call Center':
                  telepon();
                  break;
                case 'SMS Center':
                  kirimSms();
                  break;
                case 'Location/Maps':
                  bukaPeta();
                  break;
                case 'Update User & Password':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateCredentialsScreen(),
                    ),
                  );
                  break;
                case 'Logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {
                'Call Center',
                'SMS Center',
                'Location/Maps',
                'Update User & Password',
                'Logout'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.background,
            child: ListView(
              children: [
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 750),
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: gapped([
                        Text("Ajib Tea & Pastry Shop",
                            style: Theme.of(context).textTheme.displaySmall),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: Image.asset("assets/culinary.jpg"),
                        ),
                        Center(
                          child: SizedBox(
                            width: 275,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                tombolEmail(),
                                tombolTelphone(),
                                tombolPeta()
                              ],
                            ),
                          ),
                        ),
                        Text("Deskripsi",
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                          "**Warung Ajib** adalah tempat yang pas buat kamu yang ingin menikmati hidangan segar dan menyegarkan! Dengan tagline *Semuanya Ajib*, kami menghadirkan aneka menu spesial yang siap memuaskan selera.",
                          style: (Theme.of(context).textTheme.bodyMedium),
                          textAlign: TextAlign.center,
                        ),
                        Text("List Menu",
                            style: Theme.of(context).textTheme.headlineSmall),

                        // Grid layout untuk menu
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.8,
                          children: [
                            MenuItem(
                                name: "Lychee Tea",
                                img: "lychee_tea.jpg",
                                description: "Enak dan segar.",
                                price: 45000,
                                onTap: () => updateTotal(Item(name: "Lychee Tea", price: 45000))),
                            MenuItem(
                                name: "Lime Tea",
                                img: "lime_tea.jpg",
                                description: "Enak dan segar.",
                                price: 25000,
                                onTap: () => updateTotal(Item(name: "Lime Tea", price: 25000))),
                            MenuItem(
                                name: "Croissant",
                                img: "croissant.jpg",
                                description: "Renyah dan manis.",
                                price: 3000,
                                onTap: () => updateTotal(Item(name: "Croissant", price: 3000))),
                            MenuItem(
                                name: "Pain au Chocolat",
                                img: "pain_au_choc.jpg",
                                description: "Lezat dan manis.",
                                price: 20000,
                                onTap: () => updateTotal(Item(name: "Pain au Chocolat", price: 20000))),
                            MenuItem(
                                name: "Palmier",
                                img: "palmier.jpg",
                                description: "Gurih dan renyah.",
                                price: 25000,
                                onTap: () => updateTotal(Item(name: "Palmier", price: 25000))),
                            MenuItem(
                                name: "Puff Pastry Cheese",
                                img: "puff_pastry_cheeseknees.jpg",
                                description: "Keju yang melimpah.",
                                price: 60000,
                                onTap: () => updateTotal(Item(name: "Puff Pastry Cheese", price: 60000))),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Total harga
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      total: totalHarga,
                      onPaymentSuccess: resetTotal,
                      items: purchasedItems, // Pass purchased items
                    ),
                  ),
                );
              },
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Total: Rp.${totalHarga}",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.name,
    required this.img,
    required this.description,
    required this.price,
    required this.onTap,
  });

  final String name, description, img;
  final int price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              onTap: onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image.asset(
                      "assets/dishes/$img",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(name),
                    content: Text(description),
                    actions: [
                      TextButton(
                        child: Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(name, style: Theme.of(context).textTheme.bodyLarge),
          ),
          const SizedBox(height: 4),
          Text("Rp.${price}", style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

ElevatedButton tombolEmail() =>
    const ElevatedButton(onPressed: kirimEmail, child: Icon(Icons.email));
ElevatedButton tombolTelphone() =>
    const ElevatedButton(onPressed: telepon, child: Icon(Icons.phone));
ElevatedButton tombolPeta() =>
    const ElevatedButton(onPressed: bukaPeta, child: Icon(Icons.map));

void kirimEmail() async {
  Uri uri = Uri(
      scheme: "mailto",
      path: "estehajib@gmail.com",
      query: "subject=Tanya Seputar Resto");
  if (!await launchUrl(uri)) {
    throw Exception("Gagal membuka link!");
  }
}

void telepon() async {
  Uri uri = Uri(scheme: "tel", path: "085602004718");
  if (!await launchUrl(uri)) {
    throw Exception("Gagal membuka link!");
  }
}

void kirimSms() async {
  Uri uri = Uri(scheme: "sms", path: "085602004718");
  if (!await launchUrl(uri)) {
    throw Exception("Gagal membuka link!");
  }
}

void bukaPeta() async {
  Uri uri =
      Uri(scheme: "geo", path: "-7.022162,110.506912", query: "q=Es Teh Ajib");
  if (!await launchUrl(uri)) {
    throw Exception("Gagal membuka link!");
  }
}
