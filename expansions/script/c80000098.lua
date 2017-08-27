--口袋妖怪 波克基古
function c80000098.initial_effect(c)
	c:SetSPSummonOnce(80000098)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(Card.IsSetCard,0x2d0),1)
	c:EnableReviveLimit() 
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c80000098.syncon)
	e1:SetTarget(c80000098.syntg)
	e1:SetValue(1)
	e1:SetOperation(c80000098.synop)
	c:RegisterEffect(e1) 
	--hand synchro for double tuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(c80000098.syncon)
	e3:SetCode(80000098)
	c:RegisterEffect(e3) 
	--synchro limit
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetValue(c80000098.synlimit)
	c:RegisterEffect(e13)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000098,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c80000098.discon)
	e2:SetTarget(c80000098.distg)
	e2:SetOperation(c80000098.disop)
	c:RegisterEffect(e2)  
end
function c80000098.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and tp==Duel.GetTurnPlayer()
	and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c80000098.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c80000098.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c80000098.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2d0)
end
function c80000098.synfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c80000098.synfilter2(c,syncard,tuner,f,g,lv,minc,maxc)
	if c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c)) then
		lv=lv-c:GetLevel()
		if lv<0 then return false end
		if lv==0 then return minc==1 end
		return g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc-1,maxc-1,syncard)
	else return false end
end
function c80000098.syncon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c80000098.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g1=Duel.GetMatchingGroup(c80000098.synfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	return g1:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
		or Duel.IsExistingMatchingCard(c80000098.synfilter2,tp,LOCATION_HAND,0,1,nil,syncard,c,f,g1,lv,minc,maxc)
end
function c80000098.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g1=Duel.GetMatchingGroup(c80000098.synfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local g2=Duel.GetMatchingGroup(c80000098.synfilter2,tp,LOCATION_HAND,0,nil,syncard,c,f,g1,lv,minc,maxc)
	if not g1:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
		or (g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80000098,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=g2:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if lv>tc:GetLevel() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local tg=g1:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-tc:GetLevel(),minc-1,maxc-1,syncard)
			sg:Merge(tg)
		end
		Duel.SetSynchroMaterial(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=g1:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
		Duel.SetSynchroMaterial(sg)
	end
end