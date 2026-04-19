import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../user_data.dart';
import '../models/transaction_model.dart';

class BalanceEditorScreen extends StatefulWidget {
  const BalanceEditorScreen({super.key});

  @override
  State<BalanceEditorScreen> createState() => _BalanceEditorScreenState();
}

class _BalanceEditorScreenState extends State<BalanceEditorScreen> {
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userNumberController = TextEditingController();
  final TextEditingController _tillNumberController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _balanceController.text = UserData.balance.value.toStringAsFixed(2);
    _storeNameController.text = UserData.qrStoreName.value;
    _userNameController.text = UserData.userName.value;
    _userNumberController.text = UserData.userNumber.value;
    _tillNumberController.text = UserData.qrTillNumber.value;
    _ipController.text = UserData.serverIp.value;
  }

  // --- Dialog to Add or Edit Contact ---
  void _showContactDialog({int? index}) {
    final isEditing = index != null;
    final Map<String, String> contact = isEditing
        ? UserData.contacts.value[index]
        : {"name": "", "number": "", "initials": "", "accountTitle": ""};

    final nameController = TextEditingController(text: contact['name']);
    final numberController = TextEditingController(text: contact['number']);
    final titleController = TextEditingController(text: contact['accountTitle']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? "Edit Contact" : "Add New Contact"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Saved Name (e.g. Mom)"),
              ),
              TextField(
                controller: numberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Mobile Number"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Account Holder Name",
                  helperText: "Appears on Receipt 'Account Details'",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              String initials = nameController.text.isNotEmpty
                  ? nameController.text.substring(0, 1).toUpperCase()
                  : "U";

              if (nameController.text.split(" ").length > 1) {
                initials = nameController.text.split(" ").take(2).map((e) => e[0].toUpperCase()).join();
              }

              final newData = {
                "name": nameController.text,
                "number": numberController.text,
                "initials": initials,
                "accountTitle": titleController.text.isNotEmpty
                    ? titleController.text
                    : nameController.text.toUpperCase(),
              };

              if (isEditing) {
                UserData.updateContact(index, newData);
              } else {
                UserData.addContact(newData);
              }

              Navigator.pop(ctx);
            },
            child: Text(isEditing ? "Update" : "Save"),
          ),
        ],
      ),
    );
  }

  // --- Dialog for Deletion Confirmation ---
  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete '${UserData.contacts.value[index]['name']}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              UserData.deleteContact(index);
              Navigator.pop(ctx);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // --- Dialog to Add or Edit Transaction ---
  void _showTransactionDialog({int? index}) {
    final isEditing = index != null;
    TransactionModel? existingTx;
    if (isEditing) {
      existingTx = UserData.transactions.value[index];
    }

    final nameController = TextEditingController(text: existingTx?.receiverName ?? "");
    final amountController = TextEditingController(text: existingTx?.amount.toString() ?? "");
    final typeController = TextEditingController(text: existingTx?.type ?? "Money Transfer");
    DateTime selectedDate = existingTx?.dateTime ?? DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);
    bool isSent = existingTx?.isSent ?? true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? "Edit Transaction" : "Add Dummy Transaction"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Receiver/Sender Name"),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Amount (Rs.)"),
                ),
                DropdownButtonFormField<String>(
                  value: ["Money Transfer", "Raast QR Payment", "Easypaisa Mobile Load"].contains(typeController.text) 
                      ? typeController.text 
                      : "Money Transfer",
                  items: ["Money Transfer", "Raast QR Payment", "Easypaisa Mobile Load"]
                      .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                      .toList(),
                  onChanged: (val) => typeController.text = val!,
                  decoration: const InputDecoration(labelText: "Type"),
                ),
                const SizedBox(height: 10),
                // SENT / RECEIVED TOGGLE
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSent ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isSent ? "Money Sent (Red)" : "Money Received (Green)",
                        style: TextStyle(
                          color: isSent ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: isSent,
                        activeColor: Colors.red,
                        inactiveThumbColor: Colors.green,
                        inactiveTrackColor: Colors.green.withOpacity(0.5),
                        onChanged: (val) => setDialogState(() => isSent = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) setDialogState(() => selectedDate = date);
                  },
                ),
                ListTile(
                  title: Text("Time: ${selectedTime.format(context)}"),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) setDialogState(() => selectedTime = time);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                final tx = TransactionModel(
                  type: typeController.text,
                  bankName: existingTx?.bankName ?? "easypaisa",
                  receiverName: nameController.text,
                  contactNumber: existingTx?.contactNumber ?? "",
                  dateTime: DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  ),
                  amount: double.tryParse(amountController.text) ?? 0.0,
                  isSent: isSent,
                  isDummy: existingTx?.isDummy ?? true,
                );
                
                if (isEditing) {
                  UserData.updateTransaction(index, tx);
                } else {
                  UserData.addTransaction(tx);
                }
                Navigator.pop(ctx);
              },
              child: Text(isEditing ? "Update" : "Add"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Developer Menu"),
        backgroundColor: const Color(0xFF00AA4F),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: BALANCE ---
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("MAIN BALANCE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _balanceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixText: "Rs. ",
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00AA4F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        onPressed: () {
                          double? newAmount = double.tryParse(_balanceController.text);
                          if (newAmount != null) {
                            UserData.setBalance(newAmount);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Balance Updated!")),
                            );
                          }
                        },
                        child: const Text("Set"),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1, height: 1),

            // --- SECTION 4: SERVER IP ---
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("SERVER CONFIGURATION", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 15),
                  ValueListenableBuilder<String>(
                    valueListenable: UserData.serverIp,
                    builder: (context, currentIp, child) {
                      return Text("Current IP: $currentIp", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500));
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ipController,
                          decoration: const InputDecoration(
                            labelText: "New Server IP",
                            hintText: "e.g. 192.168.100.9",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00AA4F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        onPressed: () {
                          if (_ipController.text.isNotEmpty) {
                            UserData.setServerIp(_ipController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Server IP Updated!")),
                            );
                          }
                        },
                        child: const Text("Save"),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1, height: 1),

            // --- SECTION 2: USER INFO ---
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("USER INFO (ME)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      labelText: "Your Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _userNumberController,
                    decoration: const InputDecoration(
                      labelText: "Your Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00AA4F),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        UserData.setUserInfo(
                          _userNameController.text,
                          _userNumberController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User Info Updated!")),
                        );
                      },
                      child: const Text("Save User Info"),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1, height: 1),

            // --- SECTION: QR STORE INFO ---
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("QR STORE INFO", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 15),
                  ValueListenableBuilder<bool>(
                    valueListenable: UserData.isAutoQr,
                    builder: (context, isAuto, _) {
                      return Row(
                        children: [
                          const Text("Written", style: TextStyle(fontWeight: FontWeight.w500)),
                          Switch(
                            value: isAuto,
                            activeColor: const Color(0xFF00AA4F),
                            onChanged: (val) => UserData.setIsAutoQr(val),
                          ),
                          const Text("Auto", style: TextStyle(fontWeight: FontWeight.w500)),
                          const Spacer(),
                          if (isAuto)
                            const Text("(Extracts name from QR)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _storeNameController,
                    decoration: const InputDecoration(
                      labelText: "Store Name (Manual)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _tillNumberController,
                    decoration: const InputDecoration(
                      labelText: "Till Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00AA4F),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        UserData.setQrStoreInfo(
                          _storeNameController.text,
                          _tillNumberController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("QR Store Info Updated!")),
                        );
                      },
                      child: const Text("Save QR Store Info"),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1, height: 1),

            // --- SECTION 3: TRANSACTIONS ---
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("TRANSACTION HISTORY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      IconButton(
                        onPressed: () {
                          UserData.clearTransactions();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("History Cleared!")),
                          );
                        },
                        icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                        tooltip: "Clear All History",
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _showTransactionDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text("Add New Dummy Transaction"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text("ALL TRANSACTIONS (EDITABLE)", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 5),
                  ValueListenableBuilder<List<TransactionModel>>(
                    valueListenable: UserData.transactions,
                    builder: (context, transactions, child) {
                      final allTxs = transactions.asMap().entries.toList();
                      if (allTxs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text("No transactions found.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allTxs.length,
                        itemBuilder: (context, index) {
                          final entry = allTxs[index];
                          final tx = entry.value;
                          final originalIndex = entry.key;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text("${tx.receiverName} - Rs. ${tx.amount}"),
                              subtitle: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: tx.isSent ? Colors.red : Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      tx.isSent ? "SENT" : "RECEIVED",
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text("${tx.type} | ${DateFormat('dd MMM, h:mm a').format(tx.dateTime)}", overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!tx.isDummy)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Tooltip(
                                        message: "Real Transaction",
                                        child: Icon(Icons.verified, size: 16, color: Colors.green),
                                      ),
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                                    onPressed: () => _showTransactionDialog(index: originalIndex),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                    onPressed: () => UserData.deleteTransaction(originalIndex),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1, height: 1),

            // --- CONTACTS HEADER ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("SAVED CONTACTS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  IconButton(
                    onPressed: () => _showContactDialog(),
                    icon: const Icon(Icons.add_circle, color: Color(0xFF00AA4F)),
                  )
                ],
              ),
            ),

            ValueListenableBuilder<List<Map<String, String>>>(
                valueListenable: UserData.contacts,
                builder: (context, contactsList, child) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: contactsList.length,
                    separatorBuilder: (c, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final contact = contactsList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF00AA4F).withOpacity(0.1),
                          child: Text(contact['initials'] ?? "U", style: const TextStyle(color: Color(0xFF00AA4F))),
                        ),
                        title: Text(contact['name'] ?? "Unknown"),
                        subtitle: Text("${contact['number']}\nTitle: ${contact['accountTitle'] ?? 'N/A'}"),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => _showDeleteConfirmationDialog(index),
                        ),
                      );
                    },
                  );
                }
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
