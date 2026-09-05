---
name: ui-ux-requirement
description: Phân tích và đặc tả yêu cầu UI/UX - Layout, interaction, state, responsive, accessibility từ design spec hoặc wireframe.
---

# UI/UX Requirement Specification

## Purpose
Bóc tách và tài liệu hóa tất cả yêu cầu hiển thị, tương tác và trải nghiệm người dùng trước khi Dev FE triển khai.

## Output cần tạo

### 1. Layout & Visual Spec
- Mô tả cấu trúc layout: grid columns, spacing system (px / rem / tokens), alignment rules.
- Breakpoints áp dụng: mobile / tablet / desktop. Từng breakpoint thay đổi gì so với layout mặc định.
- Màu sắc, typography (font-size, weight, line-height) theo Design Token system.

### 2. Component & State Inventory
Liệt kê toàn bộ components và các states của chúng:
- Default / Hover / Focus / Active / Disabled / Loading / Empty / Error / Success.

### 3. Interaction & Behavior
- Mô tả hành vi khi người dùng tương tác: click, drag, scroll, swipe, keyboard.
- Animation / transition nếu có: duration, easing, trigger.

### 4. Data Binding & API Integration
- Fields nào bind với API response.
- Skeleton loader khi đang fetch.
- Empty state UI khi data rỗng.
- Error state UI khi API thất bại — hiển thị `errorMessage` từ BE response.

### 5. Accessibility Requirements
- WCAG level yêu cầu (thường AA).
- Keyboard navigation flow.
- Screen reader labels cần thiết.

## Format output
Tài liệu dạng Markdown kèm bảng state inventory và mockup text description. Lưu tại `.roleSession/{SESSION_ID}/ui-ux-spec.md`.
