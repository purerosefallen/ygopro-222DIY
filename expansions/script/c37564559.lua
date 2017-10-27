--3倍ICE CREAM
local m=37564559
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,e)
	return c:IsCode(37564765) and c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsAbleToGrave()
end
function cm.gcheck(g,ft)
	if ft<=0 and not g:IsExists(cm.mzfilter,-ft+1,nil) then return false end
	return not g:IsExists(cm.filter1,1,nil,g)
end
function cm.mzfilter(c)
	return c:GetSequence()<5
end
function cm.filter1(c,g)
	return g:IsExists(cm.filter2,1,c,c:GetOriginalCode())
end
function cm.filter2(c,code)
	return c:GetOriginalCode()==code
end
function cm.sfilter(c,e,tp)
	return c:GetOriginalCode()==37564765 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetMZoneCount(tp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Senya.CheckGroup(g,cm.gcheck,nil,3,3,ft) end
	local tg=Senya.SelectGroup(tp,HINTMSG_TOGRAVE,g,cm.gcheck,nil,3,3,ft)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.chkfilter(c,e,tp)
	return c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) and c:IsAbleToGrave()
end
function cm.val(c)
	return math.max(c:GetBaseAttack(),0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g or g:FilterCount(cm.chkfilter,nil,e,tp)~=3 then return end
	local v=g:GetSum(cm.val)
	Duel.SendtoGrave(g,REASON_EFFECT)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=sg:GetFirst()
	if tc then
		Duel.BreakEffect()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(v)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(0x1fe1000)
		tc:RegisterEffect(e1,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(0x1fe1000)
		tc:RegisterEffect(e1,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(m*16)
		e1:SetReset(0x1fe1000)
		tc:RegisterEffect(e1,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetValue(aux.tgoval)
		e1:SetReset(0x1fe1000)
		tc:RegisterEffect(e1,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(function(e,re,tp)
			return tp~=e:GetHandlerPlayer()
		end)
		e1:SetReset(0x1fe1000)
		tc:RegisterEffect(e1,true)
		local ex=Senya.NegateEffectModule(tc,1,nil,cm.cost)
		ex:SetReset(0x1fe1000)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackAbove(2850) and not c:IsHasEffect(EFFECT_REVERSE_UPDATE) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-2850)
	e1:SetReset(0x1fe1000)
	c:RegisterEffect(e1,true)
end