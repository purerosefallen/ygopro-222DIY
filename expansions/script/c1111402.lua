--灵纹·星辉下的起舞
function c1111402.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c1111402.tg1)
	e1:SetOperation(c1111402.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c1111402.limit2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_EQUIP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c1111402.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c1111402.con4)
	e4:SetOperation(c1111402.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_EQUIP)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c1111402.op5)
	c:RegisterEffect(e5)
--
end
--
c1111402.named_with_Lw=1
function c1111402.IsLw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lw
end
function c1111402.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
function c1111402.IsDw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Dw
end
--
function c1111402.filter1(c)
	return c:IsFaceup() and c1111402.IsLd(c) and c:IsType(TYPE_MONSTER)
end
function c1111402.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1111402.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111402.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1111402.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c1111402.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--
function c1111402.limit2(e,c)
	return c1111402.IsLd(c) and c:IsType(TYPE_MONSTER)
end
--
function c1111402.op3(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=e:GetHandler():GetEquipTarget()
	if tc:GetOriginalCode()==1110131 then
		local e3_1=Effect.CreateEffect(e:GetHandler())
		e3_1:SetDescription(aux.Stringid(1111402,0))
		e3_1:SetType(EFFECT_TYPE_IGNITION)
		e3_1:SetRange(LOCATION_MZONE)
		e3_1:SetCountLimit(1)
		e3_1:SetLabelObject(e:GetHandler())
		e3_1:SetCost(c1111402.cost3_1)
		e3_1:SetCondition(c1111402.con3_1)
		e3_1:SetTarget(c1111402.tg3_1)
		e3_1:SetOperation(c1111402.op3_1)
		tc:RegisterEffect(e3_1)
		if e3_1:GetHandler()==nil then return end
	end
	if tc:GetOriginalCode()==1110151 then
		local e3_2=Effect.CreateEffect(e:GetHandler())
		e3_2:SetType(EFFECT_TYPE_FIELD)
		e3_2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3_2:SetRange(LOCATION_MZONE)
		e3_2:SetLabelObject(e:GetHandler())
		e3_2:SetTargetRange(0,1)
		e3_2:SetCondition(c1111402.con3_2)
		e3_2:SetTarget(c1111402.limit3_2)
		tc:RegisterEffect(e3_2)
		if e3_2:GetHandler()==nil then return end
	end
end
--
function c1111402.cfilter3_1(c)
	return c:IsCode(1111002) and c:IsAbleToGraveAsCost()
end
function c1111402.cost3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111402.cfilter3_1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)	
	local g=Duel.SelectMatchingCard(tp,c1111402.cfilter3_1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c1111402.con3_1(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
function c1111402.tfilter3_1(c)
	return c1111402.IsDw(c) and c:IsSSetable()
end
function c1111402.tg3_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111402.tfilter3_1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c1111402.op3_1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111402,2))  
		local g=Duel.SelectMatchingCard(tp,c1111402.tfilter3_1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			if Duel.SSet(tp,g)~=0 then
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
--
function c1111402.con3_2(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
function c1111402.limit3_2(e,c,sump,sumtype,sumpos,targetp)
	return c:GetLevel()<6
end
--
function c1111402.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
--
function c1111402.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,LOCATION_GRAVE)  
end
--
function c1111402.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
--
function c1111402.op5(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=e:GetHandler():GetEquipTarget()
	local e5_1=Effect.CreateEffect(e:GetHandler())
	e5_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5_1:SetCode(EFFECT_DESTROY_REPLACE)
	e5_1:SetRange(LOCATION_MZONE)
	e5_1:SetCountLimit(1)
	e5_1:SetLabelObject(e:GetHandler())
	e5_1:SetCondition(c1111402.con5_1)
	e5_1:SetTarget(c1111402.tg5_1)
	e5_1:SetOperation(c1111402.op5_1)
	tc:RegisterEffect(e5_1)
	if e5_1:GetHandler()==nil then return end
end
function c1111402.con5_1(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
function c1111402.tfilter5_1(c,tp)
	return c:IsFaceup() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c1111402.tg5_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111402.tfilter5_1,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	return Duel.SelectYesNo(tp,aux.Stringid(1111402,1)) 
end
function c1111402.op5_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111402,3))
	local g=Duel.SelectMatchingCard(tp,c1111402.tfilter5_1,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
