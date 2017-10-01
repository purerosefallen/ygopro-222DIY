--Prim
local m=37564013
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
cm.Senya_name_with_prim=true
function cm.initial_effect(c)
	--Senya.setreg(c,m,37564600)
	Senya.AddXyzProcedureRank(c,4,nil,2,63)
	--攻击上升
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(cm.atkval)
	c:RegisterEffect(e8)
	--3属性不会成为对象
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	e3:SetCondition(cm.XMaterialCountCondition(3))
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetCondition(cm.XMaterialCountCondition(3))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--2属性吸素材
	Senya.AttackOverlayDrainEffect(c,cm.XMaterialCountCondition(2),cm.destg)
	--4属性3康
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCountLimit(1)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.discon)
	e6:SetTarget(cm.distg)
	e6:SetOperation(cm.disop)
	c:RegisterEffect(e6)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,13))
	e9:SetCategory(CATEGORY_REMOVE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetHintTiming(0,0x1e0)
	e9:SetCountLimit(1)
	e9:SetCondition(cm.XMaterialCountCondition(5))
	e9:SetTarget(cm.tdtg)
	e9:SetOperation(cm.tdop)
	c:RegisterEffect(e9)
	--6属性变身
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.XMaterialCountCondition(6))
	e7:SetCost(cm.sppcost)
	e7:SetTarget(cm.spptg)
	e7:SetOperation(cm.sppop)
	c:RegisterEffect(e7)
	local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(m,14))
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e0:SetCode(EVENT_PHASE+PHASE_END)
		e0:SetRange(LOCATION_MZONE)
		e0:SetCountLimit(1)
		e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return Duel.GetTurnPlayer()==tp and e:GetHandler():GetOverlayGroup():IsExists(cm.mtfilter,1,nil)
		end)
		e0:SetTarget(cm.mttg)
		e0:SetOperation(cm.mtop)
		--c:RegisterEffect(e0)
end
function cm.mtfilter(c)
	return Senya.check_set_elem(c)
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function cm.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function cm.XMaterialCountCondition(ct)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local g=e:GetHandler():GetOverlayGroup()
		local ct1=g:Filter(cm.nfilter,nil):GetClassCount(Card.GetAttribute)
		local ct2=g:FilterCount(cm.repfilter,nil)
		local tct=ct1+ct2
		return tct>=ct
	end
end
function cm.nfilter(c)
	return c:IsType(TYPE_MONSTER) and not c.prim_replace_att
end
function cm.repfilter(c)
	return c.prim_replace_att
end
function cm.destg(c,ec)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return cm.XMaterialCountCondition(4)(e,tp,eg,ep,ev,re,r,rp) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function cm.sppcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(m)==0 end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.fffilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0
end
function cm.spptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.sppop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.fffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		for i=3,7 do
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,i))
		end
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,8))
		Duel.Hint(HINT_CARD,0,18326736)
		Duel.Hint(HINT_CARD,0,45950291)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		if sc:GetOriginalCode()==37564301 then
			for j=9,12 do
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,j))
			end
		end
	end
end

