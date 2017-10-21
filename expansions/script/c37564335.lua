--恋色的模样
local m=37564335
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.dfc_front_side=m+1
cm.fit_monster={m+1}
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(Senya.ForbiddenCost())
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)	
end
function cm.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local l=e:GetLabel()
	e:SetLabel(0)
	if chk==0 then
		local c=e:GetHandler()
		local tcode=c.dfc_front_side
		if not tcode or l~=1 then return false end
		local tempc=Senya.IgnoreActionCheck(Duel.CreateToken,tp,tcode)		
		if not tempc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return false end
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanBeRitualMaterial,e:GetHandler(),tempc)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<0 then return false end
		if ft>0 then
			return mg:CheckWithSumGreater(Card.GetRitualLevel,tempc:GetLevel(),tempc)
		else
			return mg:IsExists(cm.mfilterf,1,nil,tp,mg,tempc)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(1)
	if not cm.target(e,tp,eg,ep,ev,re,r,rp,0) or c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	local tcode=c.dfc_front_side
	local tempc=Duel.CreateToken(tp,tcode)
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanBeRitualMaterial,c,tempc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mat=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tempc:GetLevel(),tempc)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,tempc)
		Duel.SetSelectedCard(mat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tempc:GetLevel(),tempc)
		mat:Merge(mat2)
	end
	c:SetMaterial(mat)
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	Duel.SetMetatable(c,_G["c"..tcode])
	Duel.Hint(11,0,m*16)
	Duel.Hint(HINT_CARD,0,m+1)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))	
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
	c:CompleteProcedure()
end