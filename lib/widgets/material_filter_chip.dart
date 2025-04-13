import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaterialFilterChip extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  const MaterialFilterChip({super.key, this.onChanged});

  @override
  State<MaterialFilterChip> createState() => MaterialFilterChipState();
}

class MaterialFilterChipState extends State<MaterialFilterChip> {
  final List<String> _chips = [];

  void addChip(String keyword) {
    if (keyword.isNotEmpty && !_chips.contains(keyword)) {
      setState(() {
        _chips.add(keyword);
        widget.onChanged?.call(_chips.isNotEmpty);
      });
    }
  }

  void _removeChip(String chip) {
    setState(() {
      _chips.remove(chip);
      widget.onChanged?.call(_chips.isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: _chips.isEmpty ? 0 : 56.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.only(left: 17.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_chips.isNotEmpty) ...[
                FilterChip(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  label: Text('재료 등록', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  onSelected: (_) {},
                  selected: false,
                ),
              ],
              ..._chips.map((chip) => Padding(
                padding: EdgeInsets.only(left: 9.w),
                child: Chip(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  label: Text(chip, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400)),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  onDeleted: () => _removeChip(chip),
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
