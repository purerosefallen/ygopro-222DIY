--灵纹·强制缔结
function c1111401.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c1111401.tg1)
	e1:SetOperation(c1111401.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c1111401.limit2)
	c:RegisterEffect(e2)
--
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_EQUIP)
	e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetValue(800)
	c:RegisterEffect(e11)
--
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetCountLimit(1)
	e12:SetRange(LOCATION_SZONE)
	e12:SetTarget(c1111401.tg12)
	e12:SetOperation(c1111401.op12)
	c:RegisterEffect(e12)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_EQUIP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c1111401.op3)
	c:RegisterEffect(e3)
--
end
--
c1111401.named_with_Lw=1
function c1111401.IsLw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lw
end
function c1111401.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
function c1111401.IsDw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Dw
end
--
function c1111401.tfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER)
end
function c1111401.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1111401.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111401.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1111401.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
--
function c1111401.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--
function c1111401.limit2(e,c)
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER)
end
--
function c1111401.op3(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=e:GetHandler():GetEquipTarget()
	if tc:GetOriginalCode()==1110121 then
		local e3_1=Effect.CreateEffect(e:GetHandler())
		e3_1:SetDescription(aux.Stringid(1111401,0))
		e3_1:SetCategory(CATEGORY_REMOVE)
		e3_1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
		e3_1:SetCode(EVENT_BATTLE_DAMAGE)
		e3_1:SetLabelObject(e:GetHandler())
		e3_1:SetCondition(c1111401.con3_1)
		e3_1:SetTarget(c1111401.tg3_1)
		e3_1:SetOperation(c1111401.op3_1)
		tc:RegisterEffect(e3_1)
		if e3_1:GetHandler()==nil then return end
	end
	if tc:GetOriginalCode()==1110122 then
		local e3_2=Effect.CreateEffect(e:GetHandler())
		e3_2:SetDescription(aux.Stringid(1111401,1))
		e3_2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
		e3_2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
		e3_2:SetCode(EVENT_BATTLE_DAMAGE)
		e3_2:SetLabelObject(e:GetHandler())
		e3_2:SetCondition(c1111401.con3_2)
		e3_2:SetOperation(c1111401.op3_2)
		tc:RegisterEffect(e3_2)
		if e3_2:GetHandler()==nil then return end
	end
end
--
function c1111401.con3_1(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
function c1111401.tg3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x1e,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0x1e)
end
function c1111401.op3_1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(1111401,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(1111401,4))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(1111401,5))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
--
function c1111401.con3_2(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
function c1111401.op3_2(e,tp,eg,ep,ev,re,r,rp)
	local e3_2_1=Effect.CreateEffect(e:GetHandler())
	e3_2_1:SetType(EFFECT_TYPE_FIELD)
	e3_2_1:SetCode(EFFECT_IMMUNE_EFFECT)
	e3_2_1:SetTargetRange(LOCATION_ONFIELD,0)
	e3_2_1:SetReset(RESET_PHASE+PHASE_END)
	e3_2_1:SetTarget(c1111401.tg3_2_1)
	e3_2_1:SetValue(c1111401.efilter3_2_1)
	Duel.RegisterEffect(e3_2_1,tp)
end
function c1111401.tg3_2_1(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c1111401.efilter3_2_1(e,re,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
--
function c1111401.tg12(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ec=e:GetHandler():GetEquipTarget()
	ec:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ec,1,0,0)
end
--
function c1111401.op12(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec and ec:IsRelateToEffect(e) then 
		Duel.Destroy(ec,REASON_EFFECT)
	end
end
--