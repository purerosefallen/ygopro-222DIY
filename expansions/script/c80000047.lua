--口袋妖怪 火焰鸡
function c80000047.initial_effect(c)
c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000047,8))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c80000047.cost)
	e4:SetTarget(c80000047.target)
	e4:SetOperation(c80000047.operation)
	c:RegisterEffect(e4)
	--atktimes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c80000047.maop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000047,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetTarget(c80000047.destg)
	e3:SetOperation(c80000047.desop)
	c:RegisterEffect(e3)
	--disable
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetRange(LOCATION_MZONE)
	e13:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e13:SetTarget(c80000047.tg)
	e13:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e13) 
	--disable spsummon
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetTargetRange(1,1)
	e14:SetTarget(c80000047.tg1)
	c:RegisterEffect(e14)   
end
c80000047.lvdncount=2
c80000047.lvdn={80000046,80000045}
function c80000047.tg(e,c)
	return c:IsType(TYPE_PENDULUM)
end
function c80000047.tg1(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c80000047.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c80000047.filter(c)
	return c:GetCode()==80000045 and c:IsAbleToHand()
end
function c80000047.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000047.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000047.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c80000047.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c80000047.mfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c80000047.maop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	local ct=Duel.GetMatchingGroupCount(c80000047.mfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c80000047.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable() and c:IsFaceup()
end
function c80000047.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c80000047.desfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c80000047.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80000047.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end