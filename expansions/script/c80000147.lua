--晴天
function c80000147.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c80000147.aere)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)   
	--Atk/def
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTarget(c80000147.dfwe123)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetValue(-400)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8) 
	--damage amp
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c80000147.dcon)
	e4:SetOperation(c80000147.dop)
	c:RegisterEffect(e4) 
	--add counter
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000147,0))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c80000147.target)
	e5:SetOperation(c80000147.operation)
	c:RegisterEffect(e5)	 
end
function c80000147.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsCanAddCounter(0x18,1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x18,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x18,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c80000147.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsCanAddCounter(0x18,1) then
		tc:AddCounter(0x18,1)
	end
end
function c80000147.dcon(e,tp,eg,ep,ev,re,r,rp)
	return  eg:GetFirst():IsAttribute(ATTRIBUTE_FIRE) and eg:GetFirst():GetBattleTarget()~=nil
end
function c80000147.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c80000147.aere(e,c)
	return (c:IsAttribute(ATTRIBUTE_FIRE) or c:IsRace(RACE_PLANT))
end
function c80000147.dfwe123(e,c)
	return not (c:IsAttribute(ATTRIBUTE_FIRE) or c:IsRace(RACE_PLANT))
end