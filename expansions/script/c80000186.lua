--传说中的口袋妖怪 雷吉奇卡斯
function c80000186.initial_effect(c)
	--fusion material
	c:SetUniqueOnField(1,1,80000186)  
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,80000183,80000184,80000185,true,true)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c80000186.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c80000186.spcon)
	e2:SetOperation(c80000186.spop)
	c:RegisterEffect(e2) 
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3) 
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c80000186.desreptg)
	c:RegisterEffect(e4) 
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetDescription(aux.Stringid(80000186,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c80000186.tgcon)
	e5:SetCost(c80000186.discost1)
	e5:SetOperation(c80000186.op)
	c:RegisterEffect(e5)
	--wudi 
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c80000186.efilter)
	c:RegisterEffect(e6)   
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80000186,2))
	e7:SetCategory(CATEGORY_NEGATE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e7:SetCode(EVENT_CHAINING)
	e7:SetCountLimit(1)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c80000186.discost)
	e7:SetCondition(c80000186.codisable)
	e7:SetTarget(c80000186.tgdisable)
	e7:SetOperation(c80000186.opdisable)
	c:RegisterEffect(e7)   
	--spsummon
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLE_DESTROYED)
	e8:SetTarget(c80000186.target)
	e8:SetOperation(c80000186.operation)
	c:RegisterEffect(e8) 
end
function c80000186.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000186.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c80000186.spfilter(c,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsAbleToRemoveAsCost() 
end
function c80000186.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c80000186.spfilter,tp,LOCATION_ONFIELD,0,1,nil,80000183)
		and Duel.IsExistingMatchingCard(c80000186.spfilter,tp,LOCATION_ONFIELD,0,1,nil,80000184)
		and Duel.IsExistingMatchingCard(c80000186.spfilter,tp,LOCATION_ONFIELD,0,1,nil,80000185)
end
function c80000186.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c80000186.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,80000183)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c80000186.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,80000184)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c80000186.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,80000185)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c80000186.repfilter(c)
	return c:IsSetCard(0x2d0) and c:IsAbleToRemoveAsCost() and c:IsRace(RACE_ROCK)
end
function c80000186.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) 
		and Duel.IsExistingMatchingCard(c80000186.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(80000186,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c80000186.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		return true
	else return false end
end
function c80000186.cfilter(c)
	return c:IsSetCard(0x2d0) and c:IsRace(RACE_AQUA) and c:IsAbleToRemoveAsCost()
end
function c80000186.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c80000186.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000186.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80000186.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80000186.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c80000186.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c80000186.op(e,tp,eg,ep,ev,re,r,rp,chk)
		Duel.Draw(tp,2,REASON_EFFECT)
end
function c80000186.cfilter1(c)
	return c:IsSetCard(0x2d0) and c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost()
end
function c80000186.discost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000186.cfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80000186.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80000186.filter(c,e,tp)
	return (c:IsCode(80000183) or c:IsCode(80000184) or c:IsCode(80000185)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c80000186.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsExistingMatchingCard(c80000186.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,3,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c80000186.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000186.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,3,3,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c80000186.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(80000186)==0 end
	if c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		c:RegisterFlagEffect(80000186,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c80000186.opdisable(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	Duel.NegateActivation(ev)
end
function c80000186.codisable(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c80000186.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end




