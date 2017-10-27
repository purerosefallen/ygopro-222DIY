--巨大战舰 巨核Mk-2（D）
function c13257205.initial_effect(c)
	c:EnableCounterPermit(0x1f)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(13257205,1))
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SUMMON_PROC)
	e11:SetCondition(c13257205.otcon)
	e11:SetOperation(c13257205.otop)
	e11:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e11)
	--Destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c13257205.desreptg)
	e1:SetOperation(c13257205.desrepop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c13257205.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257205,3))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c13257205.atkcost)
	e4:SetTarget(c13257205.atktg)
	e4:SetOperation(c13257205.atkop)
	c:RegisterEffect(e4)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetOperation(c13257205.bgmop)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
	
end
function c13257205.otfilter(c)
	return c:IsSetCard(0x353) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c13257205.otfilter1(c)
	return c:IsSetCard(0x353) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c13257205.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13257205.otfilter,tp,LOCATION_HAND,0,c)
	local mg1=Duel.GetMatchingGroup(c13257205.otfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:GetLevel()>6 and minc<=2
		and (Duel.GetMZoneCount(tp)>0 and mg:GetCount()>=1
			or Duel.CheckTribute(c,1,1,mg1))
		or c:GetLevel()>4 and c:GetLevel()<=6 and minc<=1
			and Duel.GetMZoneCount(tp)>0 and mg:GetCount()>=1
end
function c13257205.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13257205.otfilter,tp,LOCATION_HAND,0,c)
	local mg1=Duel.GetMatchingGroup(c13257205.otfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Group.CreateGroup()
	if c:GetLevel()>6 then
		if mg:GetCount()>0 and mg1:GetCount()==0 or (mg:GetCount()>0 and mg1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13257205,2))) then
			sg=mg:Select(tp,1,1,nil)
		else
			sg=Duel.SelectTribute(tp,c,1,1,mg1)
		end
	else
		sg=mg:Select(tp,1,1,nil)
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c13257205.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
		and e:GetHandler():GetCounter(0x1f)>0 end
	return true
end
function c13257205.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1f,1,REASON_EFFECT)
end
function c13257205.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1f,3)
end
function c13257205.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1f,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1f,1,REASON_COST)
end
function c13257205.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0
		and e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK_MONSTER)==0 end
end
function c13257205.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_SET_ATTACK_FINAL)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e5:SetValue(c:GetAttack()*2)
		c:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e7:SetValue(1)
		e7:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e7)
	end
end
function c13257205.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257205,4))
end
