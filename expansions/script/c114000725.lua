--賢者の石の生成
function c114000725.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c114000725.target)
	e1:SetOperation(c114000725.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetLabel(1)
	e2:SetTarget(c114000725.mattg)
	e2:SetOperation(c114000725.matop)
	c:RegisterEffect(e2)
end
--Define
c114000725.Philosopher=1
--remove function
function c114000725.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c114000725.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c114000725.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c114000725.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c114000725.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end --field existance check
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
--material function
function c114000725.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) 
	and (c:IsSetCard(0x226) or c:IsCode(27408609) or c:IsCode(40410110))
end
function c114000725.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) 
		and c114000725.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c114000725.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():GetFlagEffect(114000725)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c114000725.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:GetHandler():RegisterFlagEffect(114000725,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c114000725.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(e:GetHandler()))
	end
end