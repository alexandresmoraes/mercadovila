import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mercadovila/app/modules/compras/compras_carrinho_store.dart';
import 'package:mercadovila/app/utils/repositories/interfaces/i_produtos_repository.dart';
import 'package:mercadovila/app/utils/repositories/produtos_repository.dart';
import 'package:mercadovila/app/utils/widgets/card_scanner_produto.dart';
import 'package:mercadovila/app/utils/widgets/global_snackbar.dart';

class ComprasScannerPage extends StatefulWidget {
  final String title;

  const ComprasScannerPage({Key? key, this.title = 'Scanner de compra'}) : super(key: key);

  @override
  ComprasScannerPageState createState() => ComprasScannerPageState();
}

class ComprasScannerPageState extends State<ComprasScannerPage> {
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
        var carrinho = Modular.get<ComprasCarrinhoStore>();

        carrinho.setSelectItem(r);
        var carrinhoItem = carrinho.addCarrinhoComprasItem();

        AnimatedSnackBar(
          desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
          snackBarStrategy: StackSnackBarStrategy(),
          builder: ((context) {
            return CardScannerProduto(
              nome: carrinhoItem.nome,
              descricao: carrinhoItem.descricao,
              preco: carrinhoItem.preco,
              quantidade: carrinhoItem.quantidade,
              unidadeMedida: carrinhoItem.unidadeMedida,
              imageUrl: carrinhoItem.imageUrl,
            );
          }),
        ).show(context);

        setState(() {
          result = scanData;
          controller.resumeCamera();
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
