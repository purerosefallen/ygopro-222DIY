--
function c17060851.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),2)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060851,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c17060851.tgtg)
	e1:SetOperation(c17060851.tgop)
	c:RegisterEffect(e1)
	--change target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060851,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c17060851.cbcon)
	e2:SetOperation(c17060851.cbop)
	c:RegisterEffect(e2)
end
c17060851.is_named_with_Fencing=1
c17060851.is_named_with_Million_Arthur=1
function c17060851.IsFencing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Fencing
end
function c17060851.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060851.lvfilter(c,tp)
	local LeftScale=c:GetLeftScale()
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c17060851.tgfilter,tp,LOCATION_DECK,0,1,nil,lv)
end
function c17060851.tgfilter(c,LeftScale)
	return c:GetLeftScale()~=LeftScale and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function c17060851.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c17060851.lvfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c17060851.lvfilter,tp,LOCATION_PZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c17060851.lvfilter,tp,LOCATION_PZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c17060851.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c17060851.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLeftScale())
	if g:GetCount()>0 then
		local gc=g:GetFirst()
		if Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(gc:GetLeftScale())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
	end
end
function c17060851.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local bt=eg:GetFirst()
	return r~=REASON_REPLACE and bt~=e:GetHandler() and bt:IsControler(tp)
end
function c17060851.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local at=Duel.GetAttacker()
		if at:IsAttackable() and not at:IsImmuneToEffect(e) and not c:IsImmuneToEffect(e) then
			Duel.CalculateDamage(at,c)
		end
	end
end