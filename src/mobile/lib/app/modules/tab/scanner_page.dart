import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vilasesmo/app/modules/carrinho/carrinho_store.dart';
import 'package:vilasesmo/app/utils/repositories/interfaces/i_produtos_repository.dart';
import 'package:vilasesmo/app/utils/repositories/produtos_repository.dart';
import 'package:vilasesmo/app/utils/widgets/card_scanner_produto.dart';
import 'package:vilasesmo/app/utils/widgets/global_snackbar.dart';

class ScannerPage extends StatefulWidget {
  final String title;

  const ScannerPage({Key? key, this.title = 'Scanner'}) : super(key: key);

  @override
  ScannerPageState createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage> {
  Barcode? result;
  QRViewController? controller;
  bool isLoading = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'BarCode');
  final IProdutosRepository produtosRepository = Modular.get<ProdutosRepository>();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 250.0 : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: (controller) => _onQRViewCreated(controller, context),
      overlay: QrScannerOverlayShape(
        borderColor: isLoading ? Colors.black : Theme.of(context).primaryColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();

      setState(() {
        isLoading = true;
      });

      var barCode = scanData.code!.length == 12 ? '0${scanData.code!}' : scanData.code.toString();
      var produtoResult = await produtosRepository.getProdutoPorCodigoBarra(barCode);

      produtoResult.fold((l) {
        GlobalSnackbar.error('Código de barras não encontrado.');

        setState(() {
          result = scanData;
          controller.resumeCamera();
        });
      }, ((r) {
        var carrinho = Modular.get<CarrinhoStore>();

        carrinho.adicionarCarrinhoItem(r.id, 1).then((value) {
          AnimatedSnackBar(
            desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
            snackBarStrategy: StackSnackBarStrategy(),
            builder: ((context) {
              var quantidade = carrinho.getCarrinhoItemQuantidade(r.id);
              debugPrint('$quantidade');

              return CardScannerProduto(
                nome: r.nome,
                descricao: r.descricao,
                preco: r.preco.toDouble(),
                quantidade: quantidade,
                unidadeMedida: r.unidadeMedida,
                imageUrl: r.imageUrl,
              );
            }),
          ).show(context);

          setState(() {
            result = scanData;
            controller.resumeCamera();
          });
        });
      }));

      setState(() {
        isLoading = false;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
