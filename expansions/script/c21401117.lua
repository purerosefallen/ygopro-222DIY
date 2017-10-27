--枪之从者 伊丽莎白·巴托里
function c21401117.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xf03),1)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0xf0f)
	--akt down
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c21401117.adcon)
	e1:SetTarget(c21401117.adtg)
	e1:SetOperation(c21401117.adop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c21401117.tkcost)
	e2:SetTarget(c21401117.tktg)
	e2:SetOperation(c21401117.tkop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c21401117.val)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c21401117.imcon)
	e4:SetValue(c21401117.efilter)
	c:RegisterEffect(e4)
end
function c21401117.adcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c21401117.filter(c)
	return c:IsFaceup() and c:GetAttack()>0 and c:GetDefense()>0
end
function c21401117.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c21401117.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21401117.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c21401117.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21401117.filter,tp,0,LOCATION_MZONE,1,1,nil)
    local sc=g:GetFirst()
    local def=sc:GetDefense()
	if def>0 and sc:GetAttack()>0 then
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-def)
		sc:RegisterEffect(e1)
	end
end
function c21401117.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,4,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,4,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+4 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401117.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21401132,0,0x4011,0,3000,8,RACE_ROCK,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c21401117.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,21401132,0,0x4011,0,3000,8,RACE_ROCK,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,21401132)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(1)
	token:RegisterEffect(e1,true)
end
function c21401117.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_MZONE,0,nil,21401132)*700
end
function c21401117.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c21401117.cfilter(c)
	return c:IsFaceup() and c:IsCode(21401132)
end
function c21401117.imcon(e)
	return Duel.IsExistingMatchingCard(c21401117.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end