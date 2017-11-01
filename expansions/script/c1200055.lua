--LA CSGA 拒絕的羅弗寇
function c1200055.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xfba),c1200055.ffilter,true)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,1200055)
	e2:SetCondition(c1200055.spcon)
	e2:SetOperation(c1200055.spop)
	c:RegisterEffect(e2)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200055,0))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c1200055.target2)
	e2:SetOperation(c1200055.operation2)
	c:RegisterEffect(e2)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1200055,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c1200055.pencon)
	e4:SetTarget(c1200055.pentg)
	e4:SetOperation(c1200055.penop)
	c:RegisterEffect(e4)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200055,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1200055.ptg)
	e2:SetOperation(c1200055.pop)
	c:RegisterEffect(e2)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200055,3))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1200055.pptg)
	e2:SetOperation(c1200055.ppop)
	c:RegisterEffect(e2)
end
function c1200055.ffilter(c)
	return not c:IsRace(RACE_WINDBEAST)
end
function c1200055.matfilter(c)
	return (c:IsSetCard(0xfba) or not c:IsRace(RACE_WINDBEAST)) and c:IsReleasable() and c:IsFaceup()
end
function c1200055.cfilter1(c,tp,g)
	return g:IsExists(c1200055.cfilter2,1,c,tp,c) and c:IsFaceup()
end
function c1200055.cfilter2(c,tp,mc)
	return ((c:IsSetCard(0xfba) and not mc:IsRace(RACE_WINDBEAST)) or (mc:IsSetCard(0xfba) and not c:IsRace(RACE_WINDBEAST)))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0 and c:IsFaceup() and mc:IsFaceup()
end
function c1200055.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c1200055.matfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c1200055.cfilter1,1,nil,tp,g)
end
function c1200055.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c1200055.matfilter,tp,LOCATION_MZONE,0,nil)
	local g1=g:FilterSelect(tp,c1200055.cfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	local g2=g:FilterSelect(tp,c1200055.cfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	Duel.Release(g1,POS_FACEUP,REASON_COST)
end
function c1200055.filter2(c)
	return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end
function c1200055.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c1200055.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1200055.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c1200055.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,0)
end
function c1200055.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local m=math.abs(tc:GetAttack()-tc:GetBaseAttack())
		Duel.Damage(1-tp,m,REASON_EFFECT)
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(m)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end
	end
end
function c1200055.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c1200055.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c1200055.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c1200055.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0xfba) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end
function c1200055.pop(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_PZONE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_PZONE,0,e:GetHandler())
	Duel.Destroy(g,REASON_COST)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) or Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0xfba)) then return false end
	local tg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0xfba)
	if tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c1200055.ppfilter(c)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_PENDULUM)
end
function c1200055.pptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1200055.ppfilter(chkc) end
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingTarget(c1200055.ppfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c1200055.ppfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c1200055.ppop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			Duel.BreakEffect()
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(tc:GetLevel()+tc:GetRank())
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			c:RegisterEffect(e2)
		end
	end
end