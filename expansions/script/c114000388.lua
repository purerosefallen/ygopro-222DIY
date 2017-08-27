--★産業ロボット Ｑ０１（キューイチ）
function c114000388.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c114000388.tg)
	e1:SetOperation(c114000388.op)
	c:RegisterEffect(e1)
	--sp/filp summon
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--temp remove function
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e4:SetCost(c114000388.rmcost)
	e4:SetTarget(c114000388.rmtg)
	e4:SetOperation(c114000388.rmop)
	c:RegisterEffect(e4)
	--temp rem on attack announce
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(42110434,0))
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(c114000388.condition)
	c:RegisterEffect(e5)
end
--trigger F
function c114000388.filter(c)
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsType(TYPE_MONSTER)
end
function c114000388.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c114000388.filter(chkc) end
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_MZONE) end 
	--X return true end
	--ref: Sorciere de Fleur VS Madolche Queen Tiaramisu (12/09/28)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(51827737,0))
	Duel.SelectTarget(tp,c114000388.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
--copy function
function c114000388.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()	if not tc then return end
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(tc:GetCode())
	c:RegisterEffect(e1)
end
--temp remove function
function c114000388.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c114000388.filter(c)
	return c:IsFaceup() and ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsAbleToRemove()
end
function c114000388.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c114000388.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c114000388.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c114000388.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c114000388.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(c114000388.retcon)
		e1:SetOperation(c114000388.retop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
			e1:SetLabel(0)
		else
			e1:SetLabel(Duel.GetTurnCount())
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c114000388.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel()
end
function c114000388.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end
--on attack announce
function c114000388.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetControler()~=tp
end