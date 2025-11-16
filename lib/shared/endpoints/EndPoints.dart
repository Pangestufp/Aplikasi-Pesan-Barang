abstract class EndPoints {
  static const String url= "http://103.67.244.45";
  static const String baseUrl = "$url/api";
  static const String imageUrl = "$url/";

  // ---------------- AUTH ----------------
  static const String login = "$baseUrl/Auth/Login";
  static const String register = "$baseUrl/Auth/Register";
  static const String logout = "$baseUrl/Auth/Logout";

  // ---------------- PENGGUNA ----------------
  static const String penggunaMyData = "$baseUrl/Pengguna/GetMyData";

  // ---------------- PROFIL TOKO ----------------
  static const String profilTokoUpdate = "$baseUrl/ProfilToko/Update";
  static const String profilTokoGet = "$baseUrl/ProfilToko/Get";
  static const String barangReadAllWithPartPrice = "$baseUrl/Barang/ReadAllWithPartnerPrice";

  static const String barangReadById = "$baseUrl/Barang/ReadById";
  static const String barangKeluarGetDetailById = "$baseUrl/TambahBarangKeluar/GetDetailById";
  static const String pesananCreate = "$baseUrl/Pesanan/Create";
  static const String pesananTolak = "$baseUrl/Pesanan/Tolak";
  static const String pesananSetuju = "$baseUrl/Pesanan/Setuju";
  static const String pesananGetByUser = "$baseUrl/Pesanan/GetByUser";
  static const String pesananGetById = "$baseUrl/Pesanan/GetById";


}
