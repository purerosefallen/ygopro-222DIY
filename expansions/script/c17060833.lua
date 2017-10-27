--王位贼
function c17060833.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(17060833,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,17060833)
	e0:SetTarget(c17060833.target)
	e0:SetOperation(c17060833.activate)
	c:RegisterEffect(e0)
	--pendulum set ＆ atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060833,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c17060833.pscon)
	e1:SetTarget(c17060833.pstg)
	e1:SetOperation(c17060833.psop)
	c:RegisterEffect(e1)
	--reduce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060833,2))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c17060833.atkon)
	e2:SetTarget(c17060833.atktg)
	e2:SetOperation(c17060833.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060833,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c17060833.effcon)
	e4:SetTarget(c17060833.efftg)
	e4:SetOperation(c17060833.effop)
	c:RegisterEffect(e4)
end
c17060833.is_named_with_Million_Arthur=1
function c17060833.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060833.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemove()
end
function c17060833.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,6,rc)
	else return false end
end
function c17060833.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c17060833.mfilter,tp,LOCATION_GRAVE,0,nil)
		local ft=Duel.GetMZoneCount(tp)
		return ft>-1 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17060833.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c17060833.mfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if c then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,c,c)
		mg:Merge(mg2)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,6,c)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c17060833.mfilterf,1,1,nil,tp,mg,c)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,6,c)
			mat:Merge(mat2)
		end
		c:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c17060833.pscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c17060833.psfilter(c)
	return c17060833.IsMillion_Arthur(c) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060833.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c17060833.psfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c17060833.psop(e,tp,eg,ep,ev,re,r,rp)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c17060833.psfilter(chkc) end
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c17060833.psfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	local atk=tc:GetLeftScale()
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(math.ceil(atk*300))
			c:RegisterEffect(e2)
		end
	end
end
function c17060833.atkon(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()~=1 then return false end
	local tc=eg:GetFirst()
	return tc~=e:GetHandler() and tc:IsFaceup() and tc:GetSummonPlayer()==1-tp
end
function c17060833.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c17060833.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and not tc:IsImmuneToEffect(e) then
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(-500)
		tc:RegisterEffect(e1)
		if not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
			Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end
end
function c17060833.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c17060833.efffilter(c)
	return c:GetSequence()>=5
end
function c17060833.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c17060833.efffilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
end
function c17060833.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c17060833.efffilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end