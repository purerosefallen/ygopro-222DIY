--禁忌飞球·怠惰
function c13254067.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,13254062,aux.FilterBoolFunction(c13254067.ffilter),1,true,false)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c13254067.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c13254067.sprcon)
	e2:SetOperation(c13254067.sprop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c13254067.psplimit)
	c:RegisterEffect(e3)
	--Atkchange
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(c13254067.target)
	e4:SetOperation(c13254067.operation)
	c:RegisterEffect(e4)
	--Handes
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13254067,2))
	e5:SetCategory(CATEGORY_HANDES+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,13254067)
	e5:SetTarget(c13254067.target2)
	e5:SetOperation(c13254067.operation2)
	c:RegisterEffect(e5)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(13254067,3))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,23254067)
	e6:SetTarget(c13254067.pentg)
	e6:SetOperation(c13254067.penop)
	c:RegisterEffect(e6)
	--to grave
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_RELEASE)
	e7:SetCountLimit(1,33254067)
	e7:SetOperation(c13254067.operation3)
	c:RegisterEffect(e7)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	
end
function c13254067.ffilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254067.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c13254067.cfilter(c)
	return (c:IsFusionCode(13254062) or (c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c13254067.fcheck(c,sg)
	return c:IsFusionCode(13254062) and sg:IsExists(c13254067.fcheck2,1,c)
end
function c13254067.fcheck2(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254067.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c13254067.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:IsExists(c13254067.fcheck,1,nil,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c13254067.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13254067.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c13254067.fselect,1,nil,tp,mg,sg)
end
function c13254067.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13254067.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=mg:FilterSelect(tp,c13254067.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Release(sg,REASON_COST)
end
function c13254067.psplimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c13254067.filter(c)
	return c:IsFaceup() and c:GetAttack()>300
end
function c13254067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254067.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c13254067.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13254067.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c13254067.filter1(c)
	return (c:IsCode(13254032) or c:IsCode(13254062)) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c13254067.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c13254067.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254067.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c13254067.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
end
function c13254067.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=1 then return end
	Duel.BreakEffect()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g1=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_HAND,0,ct-4,ct-4,nil)
		Duel.SendtoGrave(g1,REASON_DISCARD)
	end
end
function c13254067.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c13254067.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c13254067.operation3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(1-tp)==6000 then return end
	Duel.SetLP(1-tp,6000)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
end

