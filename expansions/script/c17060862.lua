--暗堕赛莉希尔
function c17060862.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c17060862.ffilter,2,false)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(17060862,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c17060862.fpcon)
	e0:SetOperation(c17060862.fpop)
	c:RegisterEffect(e0)
	--pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060862,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,17060862)
	e1:SetCondition(c17060862.spcon)
	e1:SetTarget(c17060862.sptg)
	e1:SetOperation(c17060862.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCondition(c17060862.spcon1)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060862,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c17060862.atcon)
	e3:SetOperation(c17060862.atop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060862,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c17060862.reptg)
	e4:SetValue(c17060862.repval)
	e4:SetOperation(c17060862.repop)
	c:RegisterEffect(e4)
end
c17060862.is_named_with_Dark_Degenerate=1
function c17060862.IsDark_Degenerate(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Dark_Degenerate
end
function c17060862.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c17060862.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c17060862.ffilter(c)
	return c17060862.IsDark_Degenerate(c)
end
function c17060862.spfilter(c,fc)
	return c17060862.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c17060862.fpcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCountFromEx(tp,PLAYER_NONE)
	local ct=-ft+1
	local g=Duel.GetReleaseGroup(tp):Filter(c17060862.spfilter,nil,c)
	return g:GetCount()>1 and (Duel.GetLocationCountFromEx(tp)>0 or g:IsExists(Card.CheckMZoneFromEx,ct,nil,tp))
end
function c17060862.fpop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCountFromEx(tp,PLAYER_NONE)
	local ct=-ft+1
	local g=Duel.GetReleaseGroup(tp):Filter(c17060862.spfilter,nil,c)
	local sg=nil
	if Duel.GetLocationCountFromEx(tp)<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		sg=g:FilterSelect(tp,Card.CheckMZoneFromEx,ct,ct,nil,tp)
		if ct<2 then
			g:Sub(sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g1=g:Select(tp,2-ct,2-ct,nil)
			sg:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		sg=g:Select(tp,2,2,nil)
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c17060862.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c17060862.IsDark_Degenerate(c)
end
function c17060862.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17060862.pcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060862.pcfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c17060862.pcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060862.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c17060862.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:GetFlagEffect(17060862)==0
		and c:IsChainAttackable()
end
function c17060862.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	Duel.ChainAttack()
end
function c17060862.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c17060862.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c17060862.repfilter,1,nil,tp)
	and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	return Duel.SelectYesNo(tp,aux.Stringid(17060862,4))
end
function c17060862.repval(e,c)
	return c17060862.repfilter(c,e:GetHandlerPlayer())
end
function c17060862.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end