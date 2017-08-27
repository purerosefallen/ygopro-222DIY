--口袋妖怪 牛蛙君
function c80000280.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c80000280.spcon)
	e1:SetOperation(c80000280.spop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000280,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c80000280.target)
	e2:SetOperation(c80000280.activate)
	c:RegisterEffect(e2)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000280,3))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c80000280.target2)
	e4:SetOperation(c80000280.operation)
	e4:SetLabel(1)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atk again
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000280,4))
	e5:SetCategory(CATEGORY_COIN)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCondition(c80000280.condition)
	e5:SetOperation(c80000280.daop)
	c:RegisterEffect(e5)
end
function c80000280.spfilter(c)
	return c:IsCode(80000278) and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,80000290)
end
function c80000280.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(tp,c80000280.spfilter,1,nil)
end
function c80000280.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c80000280.spfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c80000280.filter(c,tp)
	return c:IsCode(80000148) and c:GetActivateEffect():IsActivatable(tp)
end
function c80000280.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000280.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c80000280.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(80000280,0))
	local tc=Duel.SelectMatchingCard(tp,c80000280.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end
function c80000280.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.IsExistingMatchingCard(c80000280.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and eg:IsExists(c80000280.pfilter,1,nil) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
end
function c80000280.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c80000280.pfilter,nil,e)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
function c80000280.cfilter(c)
	return c:IsFaceup() and c:IsCode(80000148)
end
function c80000280.pfilter(c,e)
	return c:IsPosition(POS_FACEUP_ATTACK) and not c:IsAttribute(ATTRIBUTE_WATER) and (not e or c:IsRelateToEffect(e))
end
function c80000280.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c80000280.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==1 then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(c:GetAttack()/2)
	c:RegisterEffect(e1)
	Duel.ChainAttack()
	else  end
end